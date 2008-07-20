//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELMIDIController.h"

#define MIDI_ON   0x90
#define MIDI_OFF  0x80
#define MIDI_PC   0xC0

@implementation ELMIDIController

- (id)init {
  if( self = [super init] ) {
    clientName = CFStringCreateWithCString( NULL, "Elysium", 0 );
    if( clientName == NULL ) {
      NSLog( @"Cannot create client name" );
      return nil;
    }
    
    MIDIClientCreate( clientName, NULL, NULL, &midiClient );
    
    portName = CFStringCreateWithCString( NULL, "Output", 0 );
    if( portName == NULL ) {
      NSLog( @"Cannot create port name" );
      return nil;
    }
    
    MIDIOutputPortCreate( midiClient, portName, &outputPort );
    
    if( MIDIGetNumberOfDestinations() < 1 ) {
      NSLog( @"No MIDI destinations area available" );
      return nil;
    }
    
    destination = MIDIGetDestination( 0 );
    if( destination == NULL ) {
      NSLog( @"Failed to obtain MIDI output" );
      return nil;
    }
  }
  
  return self;
}

- (void)noteOn:(int)_channel note:(int)_note velocity:(int)_velocity {
  Byte data[4];
  
  data[0] = 3;
  data[1] = MIDI_ON | _channel;
  data[2] = _note;
  data[3] = _velocity;
  
  [self sendMessage:data];
}

- (void)noteOff:(int)_channel note:(int)_note velocity:(int)_velocity {
  Byte data[4];
  
  data[0] = 3;
  data[1] = MIDI_OFF | _channel;
  data[2] = _note;
  data[3] = _velocity;
  
  [self sendMessage:data];
}

- (void)programChange:(int)_channel preset:(int)_preset {
  Byte data[3];
  
  data[0] = 2;
  data[1] = MIDI_PC | _channel;
  data[2] = _preset;
  
  [self sendMessage:data];
}

- (void)sendMessage:(Byte *)_data {
  Byte buffer[128];
  
  MIDIPacketList *packetList = (MIDIPacketList *)buffer;
  
  MIDIPacket *packet = MIDIPacketListInit( packetList );
  if( packet == NULL ) {
    NSLog( @"Failure to initialize the MIDI packet list!" );
    return;
  }
  
  MIDITimeStamp timeStamp = 0;
  
  packet = MIDIPacketListAdd( packetList, 128, packet, timeStamp, _data[0], &_data[1] );
  if( packet == NULL ) {
    NSLog( @"Failure to add MIDI message to packet list!" );
    return;
  }
  
  OSStatus result = MIDISend( outputPort, destination, packetList );
  NSLog( @"Result of MIDI send = %d", result );
}

- (void)playNote:(int)_noteNumber channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
}

@end
