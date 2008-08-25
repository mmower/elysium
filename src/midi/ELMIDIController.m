//
//  ELMIDIController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELMIDIController.h"

#import <PYMIDI/PYMIDI.h>

@implementation ELMIDIController

- (id)init {
  if( self = [super init] ) {
    
    source = [[PYMIDIVirtualSource alloc] initWithName:@"Elysium virtual output"];
    [source addSender:self];
    
    PYMIDIManager*  manager = [PYMIDIManager sharedInstance];
    NSArray* endpointArray = [manager realDestinations];
    
    NSEnumerator* enumerator = [endpointArray objectEnumerator];
    PYMIDIEndpoint* endpoint;
    while( endpoint = [enumerator nextObject] ) {
      NSLog( @"Detected endpoint = %@", [endpoint displayName] );
    }
    
    // clientName = CFStringCreateWithCString( NULL, "Elysium", 0 );
    // if( clientName == NULL ) {
    //   NSLog( @"Cannot create client name" );
    //   return nil;
    // }
    // 
    // MIDIClientCreate( clientName, NULL, NULL, &midiClient );
    // 
    // portName = CFStringCreateWithCString( NULL, "Output", 0 );
    // if( portName == NULL ) {
    //   NSLog( @"Cannot create port name" );
    //   return nil;
    // }
    // 
    // MIDISourceCreate( midiClient, (CFStringRef)@"Elysium", &source );
    // 
    // MIDIOutputPortCreate( midiClient, portName, &outputPort );
    // 
    // int numDestinations = MIDIGetNumberOfDestinations();
    // if( numDestinations < 1 ) {
    //   NSLog( @"No MIDI destinations are available" );
    //   return nil;
    // }
    // 
    // destination = MIDIGetDestination( 0 );
    // if( destination == NULL ) {
    //   NSLog( @"Failed to obtain MIDI output" );
    //   return nil;
    // }
    
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
  Byte data[3];
  
  if( [delegate respondsToSelector:@selector(noteOn:velocity:channel:)] ) {
    [delegate noteOn:_note velocity:_velocity channel:_channel];
  }
  
  data[0] = MIDI_ON | _channel;
  data[1] = (Byte)_note;
  data[2] = (Byte)_velocity;
  
  NSLog( @"Calling sendMessage" );
  
  [self sendMessage:data length:3];
}

- (void)noteOff:(int)_note velocity:(int)_velocity channel:(int)_channel {
  Byte data[3];
  
  if( [delegate respondsToSelector:@selector(noteOff:velocity:channel:)] ) {
    [delegate noteOff:_note velocity:_velocity channel:_channel];
  }
  
  data[0] = MIDI_OFF | _channel;
  data[1] = (Byte)_note;
  data[2] = (Byte)_velocity;
  
  [self sendMessage:data length:3];
}

- (void)programChange:(int)_preset channel:(int)_channel {
  Byte data[2];
  
  if( [delegate respondsToSelector:@selector(programChange:channel:)] ) {
    [delegate programChange:_preset channel:_channel];
  }
  
  data[0] = MIDI_PC | _channel;
  data[1] = _preset;
  
  [self sendMessage:data length:2];
}

- (void)sendMessage:(Byte *)_data_ length:(int)_length_ {
  NSLog( @"MIDIController sendMessage" );
  
  MIDIPacketList *packetList = malloc( sizeof( MIDIPacketList ) * sizeof( Byte ) );
  NSAssert( packetList != NULL, @"Failed to allocate MIDIPacketList" );
  
  MIDIPacket *packet = MIDIPacketListInit( packetList );
  NSAssert( packet != NULL, @"Failed to initialize MIDIPacketList" );
  
  MIDITimeStamp timeStamp = 0;
  packet = MIDIPacketListAdd( packetList, sizeof( MIDIPacketList ), packet, timeStamp, _length_, _data_ );
  NSAssert( packet != NULL, @"Failed to add MIDIPacket to MIDIPacketList" );
  
  NSLog( @"MIDIController sending MIDI message(s)" );
  [source processMIDIPacketList:packetList sender:self];
  
  // OSStatus result = MIDISend( outputPort, destination, packetList );
  // NSLog( @"Result of MIDI send = %d", result );
}

- (void)playNote:(int)_noteNumber channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
}

@end
