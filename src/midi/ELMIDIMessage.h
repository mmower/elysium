//
//  ELMidiMessage.h
//  Elysium
//
//  Created by Matt Mower on 07/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

// MIDI message constants
#define MIDI_ON   0x90
#define MIDI_OFF  0x80
#define MIDI_PC   0xC0

@class ELMIDIController;

@interface ELMIDIMessage : NSObject {
  ELMIDIController        *controller;
  __strong MIDIPacketList *packetList;
  __strong MIDIPacket     *packet;
}

- (id)initWithController:(ELMIDIController *)controller;

- (void)noteOn:(int)note velocity:(int)velocity at:(UInt64)at channel:(int)channel;
- (void)noteOff:(int)note velocity:(int)velocity at:(UInt64)at channel:(int)channel;
- (void)programChange:(int)preset at:(UInt64)at channel:(int)channel;

- (void)send;

@end
