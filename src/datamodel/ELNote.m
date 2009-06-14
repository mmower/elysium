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

#pragma mark Class behaviours

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
      int octaveNr = floor( noteNum / 12 ) - 1;

      [noteToNoteNames setObject:[noteName stringByAppendingFormat:@"%d", octaveNr]
                          forKey:[NSNumber numberWithInt:noteNum]];
      [noteToAltNoteNames setObject:[altNoteName stringByAppendingFormat:@"%d", octaveNr]
                             forKey:[NSNumber numberWithInt:noteNum]];
      [namesToNoteNums setObject:[NSNumber numberWithInt:noteNum]
                          forKey:[noteName stringByAppendingFormat:@"%d", octaveNr]];
    }
  }
}

+ (int)noteNumber:(NSString *)noteName {
  return [[namesToNoteNums objectForKey:noteName] intValue];
}

+ (NSString *)noteName:(int)noteNum {
  return [noteToNoteNames objectForKey:[NSNumber numberWithInt:noteNum]];
}


#pragma mark Object initialization

- (id)initWithName:(NSString *)name {
  if( ( self = [super init] ) )
  {
    _name          = name;
    _number        = [ELNote noteNumber:_name];
    _octave        = floor( _number / 12 ) - 1;
    _tone          = [noteSequence objectAtIndex:(_number % 12)];
    _alternateTone = [alternateSequence objectAtIndex:(_number % 12)];
  }
  return self;
}


#pragma mark Properties

@synthesize number = _number;
@synthesize octave = _octave;
@synthesize name = _name;
@synthesize tone = _tone;
@synthesize alternateTone = _alternateTone;
@synthesize flattenedName = _alternateTone;

- (NSString *)tone:(BOOL)flat {
  if( flat ) {
    return [self alternateTone];
  } else {
    return [self tone];
  }
}

- (NSString *)description {
  return [NSString stringWithFormat:@"[%d,%@]", [self number], [self name]];
}


#pragma mark MIDI integration

- (void)prepareMIDIMessage:(ELMIDIMessage*)message
                   channel:(int)channel
                    onTime:(UInt64)onTime
                   offTime:(UInt64)offTime
                  velocity:(int)velocity
                 transpose:(int)transpose
{
  [message noteOn:([self number]+transpose) velocity:velocity at:onTime channel:channel];
  [message noteOff:([self number]+transpose) velocity:velocity at:offTime channel:channel];
}

@end
