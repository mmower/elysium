//
//  ELMidiMessage.m
//  Elysium
//
//  Created by Matt Mower on 07/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <PYMIDI/PYMIDI.h>

#import "ELMIDIController.h"
#import "ELMIDIMessage.h"

@implementation ELMIDIMessage

- (id)initWithController:(ELMIDIController *)_controller_ {
  if( ( self = [self init] ) ) {
    controller  = _controller_;
    packetList = NSAllocateCollectable( sizeof( MIDIPacketList ) * sizeof( Byte ), 0 );
    packet     = MIDIPacketListInit( packetList );
  }
  
  return self;
}

- (void)addPacketWithData:(Byte *)_data_ length:(int)_length_ timeStamp:(UInt64)_timeStamp_ {
  packet = MIDIPacketListAdd( packetList, sizeof( MIDIPacketList ), packet, _timeStamp_, _length_, _data_ );
}

- (void)play:(int)_note_ velocity:(int)_velocity_ at:(UInt64)_at_ duration:(float)_duration_ channel:(int)_channel_ {
}

- (void)noteOn:(int)_note_ velocity:(int)_velocity_ at:(UInt64)_at_ channel:(int)_channel_ {
  Byte data[3];
  
  data[0] = MIDI_ON | (_channel_ - 1);
  data[1] = (Byte)_note_;
  data[2] = (Byte)_velocity_;
  
  [self addPacketWithData:data length:3 timeStamp:_at_];
}

- (void)noteOff:(int)_note_ velocity:(int)_velocity_ at:(UInt64)_at_ channel:(int)_channel_ {
  Byte data[3];
  
  data[0] = MIDI_OFF | (_channel_ - 1);
  data[1] = (Byte)_note_;
  data[2] = (Byte)_velocity_;
  
  [self addPacketWithData:data length:3 timeStamp:_at_];
}

- (void)programChange:(int)_preset_ at:(UInt64)_at_ channel:(int)_channel_ {
  Byte data[2];
  
  data[0] = MIDI_PC | (_channel_ - 1);
  data[1] = _preset_;
  
  [self addPacketWithData:data length:2 timeStamp:_at_];
}

- (void)send {
  [controller sendPackets:packetList];
}

@end
