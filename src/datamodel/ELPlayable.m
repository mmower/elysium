//
//  ELPlayable.m
//  Elysium
//
//  Created by Matt Mower on 18/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/HostTime.h>

#import "ELPlayable.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

@implementation ELPlayable

- (void)playOnChannel:(int)_channel_ duration:(float)_duration_ velocity:(int)_velocity_ transpose:(int)_transpose_ {
  UInt64 hostTime = AudioGetCurrentHostTime();
  UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000);
  UInt64 offTime = onTime + AudioConvertNanosToHostTime(_duration_ * 1000000000);
  
  ELMIDIMessage *message = [[ELMIDIController sharedInstance] createMessage];
  [self prepareMIDIMessage:message channel:_channel_ onTime:onTime offTime:offTime velocity:_velocity_ transpose:_transpose_];
  [message send];
}

- (void)prepareMIDIMessage:(ELMIDIMessage*)_message_
                   channel:(int)_channel_
                    onTime:(UInt64)_onTime_
                   offTime:(UInt64)_offTime_
                  velocity:(int)_velocity_
                 transpose:(int)_transpose_
{
  // Should never get here
  [self doesNotRecognizeSelector:_cmd];
}

@end
