//
//  ELMIDINoteMessage.m
//  Elysium
//
//  Created by Matt Mower on 25/06/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELMIDINoteMessage.h"

@implementation ELMIDINoteMessage

#pragma mark Object initialization

- (id)initWithChannel:(Byte)channel note:(Byte)note velocity:(Byte)velocity noteOn:(BOOL)noteOn {
  if( ( self = [super init] ) ) {
    [self setChannel:channel];
    [self setNote:note];
    [self setVelocity:velocity];
    [self setNoteOn:noteOn];
  }
  
  return self;
}


#pragma mark Properties

@synthesize channel = _channel;
@synthesize note = _note;
@synthesize velocity = _velocity;
@synthesize noteOn = _noteOn;


#pragma mark Object behaviours

/*
  Determine whether this message matches the given criteria.
  
  Note: MIDI channel #1 is returned as 0
*/
- (BOOL)matchesChannelMask:(Byte)channelMask {
  return ( [self channel]+1 ) & channelMask;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"MIDINote channel:%d note:%d velocity:%d (%@)", [self channel], [self note], [self velocity], [self noteOn] ? @"ON" : @"OFF"];
}

@end
