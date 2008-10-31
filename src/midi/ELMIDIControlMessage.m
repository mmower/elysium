//
//  ELMIDIControlMessage.m
//  Elysium
//
//  Represents a MIDI CC message. This is little more than the C struct I started with however
//  it needed to be an object to be passed via performSelector type messages.
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELMIDIControlMessage.h"

@implementation ELMIDIControlMessage

- (id)initWithChannel:(Byte)_channel_ controller:(Byte)_controller_ value:(Byte)_value_ {
  if( ( self = [super init] ) ) {
    [self setChannel:_channel_];
    [self setController:_controller_];
    [self setValue:_value_];
  }
  
  return self;
}

@synthesize channel;
@synthesize controller;
@synthesize value;

/*
  Determine whether this message matches the given criteria.
  
  Note: MIDI channel #1 is returned as 0
*/
- (BOOL)matchesChannelMask:(Byte)_channelMask_ andController:(Byte)_controller_ {
  return ( ( [self channel]+1 ) & _channelMask_ ) && ( [self controller] == _controller_ );
}

- (NSString *)description {
  return [NSString stringWithFormat:@"MIDI CC channel:%d controller:%d value:%d", [self channel], [self controller], [self value]];
}

@end
