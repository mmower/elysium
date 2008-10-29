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

@synthesize delegate;

- (ELMIDIMessage *)createMessage {
  return [[ELMIDIMessage alloc] initWithController:self];
}

- (void)sendPackets:(MIDIPacketList *)_packetList_ {
  // NSLog( @"Send MIDI packets" );
  [source processMIDIPacketList:_packetList_ sender:self];
}

- (void)setInput:(PYMIDIEndpoint *)_endpoint_ {
  [endpoint removeReceiver:self];
  endpoint = _endpoint_;
  NSLog( @"Setting input endpoint: %@ (%@)", [endpoint name], [endpoint displayName] );
  [endpoint addReceiver:self];
}

- (void)processMIDIPacketList:(MIDIPacketList *)_packetList_ sender:(id)_sender_ {
  int i, j;
  const MIDIPacket* packet;
  Byte  message[256];
  int messageSize = 0;
  
  // Step through each packet
  packet = _packetList_->packet;
  for( i = 0; i < _packetList_->numPackets; i++ ) {
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
          
          message[messageSize++] = packet->data[j];			// push the data into the message
      }
      
      packet = MIDIPacketNext (packet);
  }
  
  if (messageSize > 0)
      [self handleMIDIMessage:message ofSize:messageSize];
}

- (void)handleMIDIMessage:(Byte*)_message_ ofSize:(int)_size_ {
  // Look for Control Change
  if( ( _message_[0] & 0xF0) == 0xB0) {
    // int channel = _message_[0] & 0x0F;
    int control = _message_[1];
    int value = _message_[2];
    
    switch( control ) {
      case 0x08:
        switch( value ) {
          case 0x00:
            NSLog( @"Receved player stop control change message." );
            [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyPlayerShouldStop object:self];
            break;
          case 0x7F:
            NSLog( @"Receved player start control change message." );
            [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyPlayerShouldStart object:self];
            break;
          default:
            // NSLog( @"Received unhandled control change message %d/%d/%d", channel, control, value );
            ;
        }
        break;
      default:
        // NSLog( @"Received unhandled control change message %d/%d/%d", channel, control, value );
        ;
    }
  }
}

@end
