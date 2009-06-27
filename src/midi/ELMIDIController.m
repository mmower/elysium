//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <PYMIDI/PYMIDI.h>

#import "Elysium.h"

#import "ElysiumDocument.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"
#import "ELMIDINoteMessage.h"
#import "ELMIDIControlMessage.h"

static ELMIDIController *singletonInstance = nil;

@implementation ELMIDIController

#pragma mark Class initialization & behaviours

+ (void)initialize {
  if( nil == singletonInstance ) {
    singletonInstance = [[ELMIDIController alloc] init];
  }
}


+ (ELMIDIController *)sharedInstance {
  return singletonInstance;
}


#pragma mark Object initialization

- (id)init {
  if( ( self = [super init] ) ) {
    _source = [[PYMIDIVirtualSource alloc] initWithName:@"Elysium out"];
    [_source addSender:self];
  }
  
  return self;
}


#pragma mark Properties

@synthesize delegate = _delegate;


#pragma mark Object behaviours

- (ELMIDIMessage *)createMessage {
  return [[ELMIDIMessage alloc] initWithController:self];
}


- (void)sendPackets:(MIDIPacketList *)packetList {
  [_source processMIDIPacketList:packetList sender:self];
}


- (void)setInput:(PYMIDIEndpoint *)endpoint {
  [_endpoint removeReceiver:self];
  _endpoint = endpoint;
  [_endpoint addReceiver:self];
}


- (void)processMIDIPacketList:(MIDIPacketList *)packetList sender:(id)sender {
  int i, j;
  const MIDIPacket* packet;
  Byte  message[256];
  int messageSize = 0;
  
  // Step through each packet
  packet = packetList->packet;
  for( i = 0; i < packetList->numPackets; i++ ) {
      for( j = 0; j < packet->length; j++ ) {
          if( packet->data[j] >= 0xF8 ) {
            // skip over real-time data
            continue;
          }
          
          // Hand off the packet for processing when the next one starts
          if( ( packet->data[j] & 0x80 ) != 0 && messageSize > 0 ) {
              [self handleMIDIMessage:message ofSize:messageSize];
              messageSize = 0;
          }
          
          message[messageSize++] = packet->data[j]; // push the data into the message
      }
      
      packet = MIDIPacketNext( packet );
  }
  
  if( messageSize > 0 ) {
    [self handleMIDIMessage:message ofSize:messageSize];
  }
}


/* Handle routing MIDI control messages to the foreground player.
 * The message is bundled into a struct for easy passing.
 */
- (void)handleMIDIMessage:(Byte*)message ofSize:(int)size {
  // Look for Control Change
  if( ( message[0] & 0xF0) == 0xB0) {
    Byte channel    = message[0] & 0x0F;
    Byte controller = message[1];
    Byte value      = message[2];
    
    ELMIDIControlMessage *message = [[ELMIDIControlMessage alloc] initWithChannel:channel
                                                                       controller:controller
                                                                            value:value];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyMIDIControl object:message];
    
  } else if( ( message[0] & 0xF0 ) == 0x90 ) {
    Byte channel  = message[0] & 0x0F;
    Byte note     = message[1];
    Byte velocity = message[2];
    
    ELMIDINoteMessage *message = [[ELMIDINoteMessage alloc] initWithChannel:channel
                                                                       note:note
                                                                   velocity:velocity
                                                                     noteOn:(velocity > 0)];
                                                                     
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyMIDINote object:message];
  }
}


@end
