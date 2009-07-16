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
  // UInt64 hostTime = AudioGetCurrentHostTime();
  // UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000);
  // UInt64 offTime = onTime + AudioConvertNanosToHostTime(duration * 1000000);
  // 
  // NSLog( @"duration  = %d", duration );
  // NSLog( @"onTime    = %llu", onTime );
  // NSLog( @"offTIme   = %llu", offTime );
  // NSLog( @"difference = %llu", (offTime - onTime) );
  // 
  // ELMIDIMessage *message = [[ELMIDIController sharedInstance] createMessage];
  // [self prepareMIDIMessage:message channel:channel onTime:onTime offTime:offTime velocity:velocity transpose:transpose];
  // [message send];
}

- (void)playOnChannel:(int)channel duration:(int)duration velocity:(int)velocity transpose:(int)transpose offset:(int)offset {
  UInt64 hostTime = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
  UInt64 rebaseTime = offset * 1000;
  UInt64 onTime = hostTime + compTime + rebaseTime;
  UInt64 noteTime = ((UInt64)duration) * 1000000;
  UInt64 offTime = onTime + noteTime;
  
  // NSLog( @"duration   = %d", duration );
  // NSLog( @"rebase     = %-24llu", rebaseTime );
  // NSLog( @"hostTime   = %-24llu", hostTime );
  // NSLog( @"compTime   = %-24llu", compTime );
  // NSLog( @"onTime     = %-24llu (offset=%24llu)", onTime, (onTime - hostTime) );
  // NSLog( @"noteTime   = %-24llu", noteTime );
  // NSLog( @"offTime    = %-24llu (offset=%24llu)", offTime, (offTime - hostTime) );
  // NSLog( @"difference = %-24llu", (offTime - onTime) );
  
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
