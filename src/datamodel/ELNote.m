//
//  ELNote.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELNote.h"
#import "ELMIDIMessage.h"

static NSMutableDictionary *noteToNoteNames = nil;
static NSMutableDictionary *namesToNoteNums = nil;
static NSMutableDictionary *noteToAltNoteNames = nil;
static NSArray *noteSequence = nil;
static NSArray *alternateSequence = nil;

@implementation ELNote

+ (void)initialize {
  if( noteSequence == nil ) {
    noteSequence = [NSArray arrayWithObjects:@"C",@"C#",@"D",@"D#",@"E",@"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
    alternateSequence = [NSArray arrayWithObjects:@"C",@"Db",@"D",@"Eb",@"E",@"F",@"Gb",@"G",@"Ab",@"A",@"Bb",@"B",nil];
    
    noteToNoteNames = [[NSMutableDictionary alloc] init];
    namesToNoteNums = [[NSMutableDictionary alloc] init];
    noteToAltNoteNames = [[NSMutableDictionary alloc] init];
    
    for( int noteNum = 0; noteNum < 127; noteNum++ ) {
      NSString *noteName = [noteSequence objectAtIndex:(noteNum % 12)];
      NSString *altNoteName = [alternateSequence objectAtIndex:(noteNum % 12)];
      int octave = floor( noteNum / 12 ) - 1;

      [noteToNoteNames setObject:[noteName stringByAppendingFormat:@"%d", octave]	forKey:[NSNumber numberWithInt:noteNum]];
      [noteToAltNoteNames setObject:[altNoteName stringByAppendingFormat:@"%d", octave] forKey:[NSNumber numberWithInt:noteNum]];
      [namesToNoteNums setObject:[NSNumber numberWithInt:noteNum] forKey:[noteName stringByAppendingFormat:@"%d", octave]];
    }
  }
}

+ (int)noteNumber:(NSString *)noteName {
  return [[namesToNoteNums objectForKey:noteName] intValue];
}

+ (NSString *)noteName:(int)noteNum {
  return [noteToNoteNames objectForKey:[NSNumber numberWithInt:noteNum]];
}

- (id)initWithName:(NSString *)_name_ {
  if( ( self = [super init] ) )
  {
    name          = _name_;
    number        = [ELNote noteNumber:_name_];
    octave        = floor( number / 12 ) - 1;
    tone          = [noteSequence objectAtIndex:(number % 12)];
    alternateTone = [noteToAltNoteNames objectForKey:[NSNumber numberWithInt:(number)]];
  }
  return self;
}

- (int)number {
  return number;
}

- (NSString *)name {
  return name;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"[%d,%@]", number, name];
}

- (int)octave {
  return octave;
}

- (NSString *)tone {
  return tone;
}

- (NSString *)alternateTone {
  return alternateTone;
}

- (NSString *)tone:(BOOL)_flat_ {
  if( _flat_ ) {
    return alternateTone;
  } else {
    return tone;
  }
}

- (NSString *)flattenedName {
  return alternateTone;
}

- (void)prepareMIDIMessage:(ELMIDIMessage*)_message_
                   channel:(int)_channel_
                    onTime:(UInt64)_onTime_
                   offTime:(UInt64)_offTime_
                  velocity:(int)_velocity_
                 transpose:(int)_transpose_
{
  [_message_ noteOn:(number+_transpose_) velocity:_velocity_ at:_onTime_ channel:_channel_];
  [_message_ noteOff:(number+_transpose_) velocity:_velocity_ at:_offTime_ channel:_channel_];
}

@end
