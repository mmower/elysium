//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <PYMIDI/PYMIDI.h>

#import "Elysium.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

static ELMIDIController *singletonInstance = nil;

@implementation ELMIDIController

+ (void)initialize {
  if( nil == singletonInstance ) {
    singletonInstance = [[ELMIDIController alloc] init];
  }
}

+ (ELMIDIController *)sharedInstance {
  return singletonInstance;
}

- (id)init {
  if( ( self = [super init] ) ) {
    
    NSLog( @"Initialzing MIDI output" );
    source = [[PYMIDIVirtualSource alloc] initWithName:@"Elysium out"];
    [source addSender:self];
    
    NSLog( @"MIDIController initialization complete." );
  }
  
  return self;
}

- (ELMIDIMessage *)createMessage {
  return [[ELMIDIMessage alloc] initWithController:self];
}

- (void)sendPackets:(MIDIPacketList *)_packetList_ {
  // NSLog( @"Send MIDI packets" );
  [source processMIDIPacketList:_packetList_ sender:self];
}

- (void)setInput:(PYMIDIEndpoint *)_endpoint_ {
  // [endpoint removeReceiever:self];
  endpoint = _endpoint_;
  NSLog( @"Setting input endpoint: %@ (%@)", [endpoint name], [endpoint displayName] );
  [endpoint addReceiver:self];
}

- (void)processMIDIPacketList:(MIDIPacketList *)_packetList_ sender:(id)_sender_ {
  NSLog( @"Whoop!" );
}

@end
