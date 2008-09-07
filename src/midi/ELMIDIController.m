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

@implementation ELMIDIController

- (id)init {
  if( ( self = [super init] ) ) {
    
    source = [[PYMIDIVirtualSource alloc] initWithName:@"Elysium"];
    [source addSender:self];
    
    PYMIDIManager*  manager = [PYMIDIManager sharedInstance];
    NSArray* endpointArray = [manager realDestinations];
    
    NSEnumerator* enumerator = [endpointArray objectEnumerator];
    PYMIDIEndpoint* endpoint;
    while( ( endpoint = [enumerator nextObject] ) ) {
      NSLog( @"Detected endpoint = %@", [endpoint displayName] );
    }
    
    NSLog( @"MIDIController initialization complete." );
  }
  
  return self;
}

- (ELMIDIMessage *)createMessage {
  return [[ELMIDIMessage alloc] initWithController:self];
}

- (void)sendPackets:(MIDIPacketList *)_packetList_ {
  NSLog( @"Send MIDI packets" );
  [source processMIDIPacketList:_packetList_ sender:self];
}

@end
