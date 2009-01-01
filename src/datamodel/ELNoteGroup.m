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

- (id)initWithNote:(ELNote *)_note_ {
  if( ( self = [super init] ) ) {
    notes = [NSMutableArray arrayWithCapacity:3];
    if( _note_ ) {
      [self addNote:_note_];
    }
  }
  
  return self;
}

- (void)addNote:(ELNote *)_note_ {
  [notes addObject:_note_];
}

- (void)prepareMIDIMessage:(ELMIDIMessage*)_message_
                   channel:(int)_channel_
                    onTime:(UInt64)_onTime_
                   offTime:(UInt64)_offTime_
                  velocity:(int)_velocity_
                 transpose:(int)_transpose_
{
  for( ELNote *note in notes ) {
    [note prepareMIDIMessage:_message_
                     channel:_channel_
                      onTime:_onTime_
                     offTime:_offTime_
                    velocity:_velocity_
                   transpose:_transpose_];
  }
}

@end
