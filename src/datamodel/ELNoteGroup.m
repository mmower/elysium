//
//  ELNoteGroup.m
//  Elysium
//
//  Created by Matt Mower on 18/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <CoreAudio/HostTime.h>

#import "ELNoteGroup.h"

#import "ELNote.h"

@implementation ELNoteGroup

#pragma mark Object initialization

- (id)initWithNote:(ELNote *)note {
  if( ( self = [super init] ) ) {
    _notes = [NSMutableArray arrayWithCapacity:3];
    if( note ) {
      [self addNote:note];
    }
  }
  
  return self;
}


#pragma mark Object behaviour

- (void)addNote:(ELNote *)note {
  [_notes addObject:note];
}


#pragma mark MIDI integration

- (void)prepareMIDIMessage:(ELMIDIMessage*)message
                   channel:(int)channel
                    onTime:(UInt64)onTime
                   offTime:(UInt64)offTime
                  velocity:(int)velocity
                 transpose:(int)transpose
{
  for( ELNote *note in _notes ) {
    [note prepareMIDIMessage:message
                     channel:channel
                      onTime:onTime
                     offTime:offTime
                    velocity:velocity
                   transpose:transpose];
  }
}

@end
