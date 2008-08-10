//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELMIDIController.h"

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
    
    MIDISourceCreate( midiClient, (CFStringRef)@"Elysium", &source );
    
    MIDIOutputPortCreate( midiClient, portName, &outputPort );
    
    int numDestinations = MIDIGetNumberOfDestinations();
    if( numDestinations < 1 ) {
      NSLog( @"No MIDI destinations are available" );
      return nil;
    }
    
    destination = MIDIGetDestination( 0 );
    if( destination == NULL ) {
      NSLog( @"Failed to obtain MIDI output" );
      return nil;
    }
    
    NSLog( @"MIDIController initialization complete." );
  }
  
  return self;
}

- (id)delegate
{
  return delegate;
}

- (void)setDelegate:(id)_delegate
{
  delegate = _delegate;
}

- (void)noteOn:(int)_note velocity:(int)_velocity channel:(int)_channel {
  Byte data[4];
  
  if( [delegate respondsToSelector:@selector(noteOn:velocity:channel:)] ) {
    [delegate noteOn:_note velocity:_velocity channel:_channel];
  }
  
  data[0] = 3;
  data[1] = MIDI_ON | _channel;
  data[2] = _note;
  data[3] = _velocity;
  
  NSLog( @"Calling sendMessage" );
  
  [self sendMessage:data];
}

- (void)noteOff:(int)_note velocity:(int)_velocity channel:(int)_channel {
  Byte data[4];
  
  if( [delegate respondsToSelector:@selector(noteOff:velocity:channel:)] ) {
    [delegate noteOff:_note velocity:_velocity channel:_channel];
  }
  
  data[0] = 3;
  data[1] = MIDI_OFF | _channel;
  data[2] = _note;
  data[3] = _velocity;
  
  [self sendMessage:data];
}

- (void)programChange:(int)_preset channel:(int)_channel {
  Byte data[3];
  
  if( [delegate respondsToSelector:@selector(programChange:channel:)] ) {
    [delegate programChange:_preset channel:_channel];
  }
  
  data[0] = 2;
  data[1] = MIDI_PC | _channel;
  data[2] = _preset;
  
  [self sendMessage:data];
}

- (void)sendMessage:(Byte *)_data {
  Byte buffer[128];
  
  NSLog( @"MIDIController sendMessage" );
  
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
  
  NSLog( @"MIDI sendMessage" );
  
  OSStatus result = MIDISend( outputPort, destination, packetList );
  NSLog( @"Result of MIDI send = %d", result );
}

- (void)playNote:(int)_noteNumber channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
}

@end
