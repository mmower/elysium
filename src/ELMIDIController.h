//
//  ELMIDIController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

@interface NSObject (ELMIDIControllerDelegate)
- (void)noteOn:(int)channel note:(int)note;
- (void)noteOff:(int)channel note:(int)note;
@end

@interface ELMIDIController : NSObject {
  id              delegate;
  
  CFStringRef     clientName;
  CFStringRef     portName;
  MIDIClientRef   midiClient;
  MIDIPortRef     outputPort;
  MIDIEndpointRef destination;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (void)noteOn:(int)channel note:(int)note velocity:(int)velocity;
- (void)noteOff:(int)channel note:(int)note velocity:(int)velocity;
- (void)programChange:(int)channel preset:(int)preset;
- (void)sendMessage:(Byte *)data;


@end