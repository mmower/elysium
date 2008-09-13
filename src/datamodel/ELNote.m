//
//  ELNote.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//

#import "Elysium.h"

#import "ELNote.h"

static NSMutableDictionary *noteToNoteNames = nil;
static NSMutableDictionary *namesToNoteNums = nil;

@implementation ELNote

+ (void)load {
  NSArray *noteSequence = [NSArray arrayWithObjects:@"C",@"C#",@"D",@"D#",@"E",@"F",@"F#",@"G",@"G#",@"A",@"A#",@"B",nil];
  
  noteToNoteNames = [[NSMutableDictionary alloc] init];
  namesToNoteNums = [[NSMutableDictionary alloc] init];
  
  for( int noteNum = 0; noteNum < 127; noteNum++ ) {
    NSString *noteName = [noteSequence objectAtIndex:(noteNum % 12)];
    int octave = floor( noteNum / 12 ) - 1;
    
    [noteToNoteNames setObject:[noteName stringByAppendingFormat:@"%d", octave]	forKey:[NSNumber numberWithInt:noteNum]];
    [namesToNoteNums setObject:[NSNumber numberWithInt:noteNum] forKey:[noteName stringByAppendingFormat:@"%d", octave]];
  }
}

+ (int)noteNumber:(NSString *)noteName {
  return [[namesToNoteNums objectForKey:noteName] intValue];
}

+ (NSString *)noteName:(int)noteNum {
  return [noteToNoteNames objectForKey:[NSNumber numberWithInt:noteNum]];
}

- (id)initWithNumber:(int)_number_
{
  if( ( self = [self init] ) )
  {
    number = _number_;
    octave = floor( _number_ / 12 ) - 1;
    name   = [ELNote noteName:number];
  }
  return self;
}

- (id)initWithName:(NSString *)_name_ {
  if( ( self = [super init] ) )
  {
    name   = _name_;
    number = [ELNote noteNumber:_name_];
    octave = floor( number / 12 ) - 1;
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

@end
