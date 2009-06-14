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

@implementation ELPlayable

- (void)playOnChannel:(int)channel duration:(int)duration velocity:(int)velocity transpose:(int)transpose {
  UInt64 hostTime = AudioGetCurrentHostTime();
  UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000);
  UInt64 offTime = onTime + AudioConvertNanosToHostTime(duration * 1000000);
  
  ELMIDIMessage *message = [[ELMIDIController sharedInstance] createMessage];
  [self prepareMIDIMessage:message channel:channel onTime:onTime offTime:offTime velocity:velocity transpose:transpose];
  [message send];
}

- (void)playOnChannel:(int)channel duration:(int)duration velocity:(int)velocity transpose:(int)transpose offset:(int)offset {
  UInt64 hostTime = AudioGetCurrentHostTime();
  UInt64 rebaseTime = AudioConvertNanosToHostTime( offset * 1000 );
  UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000) + rebaseTime;
  UInt64 offTime = onTime + AudioConvertNanosToHostTime(duration * 1000000) + rebaseTime;
  
  ELMIDIMessage *message = [[ELMIDIController sharedInstance] createMessage];
  [self prepareMIDIMessage:message channel:channel onTime:onTime offTime:offTime velocity:velocity transpose:transpose];
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
