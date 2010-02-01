//
//  ELMIDIControlMessage.m
//  Elysium
//
//  Represents a MIDI CC message. This is little more than the C struct I started with however
//  it needed to be an object to be passed via performSelector type messages.
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELMIDIControlMessage.h"

@implementation ELMIDIControlMessage

- (id)initWithChannel:(Byte)channel controller:(Byte)controller value:(Byte)value {
  if( ( self = [super init] ) ) {
    [self setChannel:channel];
    [self setController:controller];
    [self setValue:value];
  }
  
  return self;
}

@synthesize channel = _channel;
@synthesize controller = _controller;
@synthesize value = _value;

/*
  Determine whether this message matches the given criteria.
  
  Note: MIDI channel #1 is returned as 0
*/
- (BOOL)matchesChannelMask:(Byte)channelMask andController:(Byte)controller {
  return ( ( [self channel]+1 ) & channelMask ) && ( [self controller] == controller );
}

- (NSString *)description {
  return [NSString stringWithFormat:@"MIDI CC channel:%d controller:%d value:%d", [self channel], [self controller], [self value]];
}

@end
