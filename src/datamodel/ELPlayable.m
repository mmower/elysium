//
//  ELPlayable.m
//  Elysium
//
//  Created by Matt Mower on 18/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <CoreAudio/HostTime.h>

#import "ELPlayable.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

static UInt64 compTime = 50000000; /* We add a 50ms lead to all note info */

@implementation ELPlayable

- (void)playOnChannel:(int)channel duration:(int)duration velocity:(int)velocity transpose:(int)transpose {
  [self playOnChannel:channel duration:duration velocity:velocity transpose:transpose offset:0];
}

- (void)playOnChannel:(int)channel duration:(int)duration velocity:(int)velocity transpose:(int)transpose offset:(int)offset {
  UInt64 hostTime = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
  UInt64 rebaseTime = offset * 1000;
  UInt64 onTime = hostTime + compTime + rebaseTime;
  UInt64 noteTime = ((UInt64)duration) * 1000000;
  UInt64 offTime = onTime + noteTime;
  
  ELMIDIMessage *message = [[ELMIDIController sharedInstance] createMessage];
  [self prepareMIDIMessage:message
                   channel:channel
                    onTime:AudioConvertNanosToHostTime( onTime )
                   offTime:AudioConvertNanosToHostTime( offTime )
                  velocity:velocity
                 transpose:transpose];
  [message send];
}

- (void)prepareMIDIMessage:(ELMIDIMessage *)message
                   channel:(int)channel
                    onTime:(UInt64)onTime
                   offTime:(UInt64)offTime
                  velocity:(int)velocity
                 transpose:(int)transpose
{
  // Should never get here
  [self doesNotRecognizeSelector:_cmd];
}

@end
