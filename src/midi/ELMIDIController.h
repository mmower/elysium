//
//  ELMIDIController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

@class PYMIDIVirtualSource;

@interface NSObject (ELMIDIControllerDelegate)
- (void)noteOn:(int)note velocity:(int)velocity channel:(int)channel;
- (void)noteOff:(int)note velocity:(int)velocity channel:(int)channel;
- (void)programChange:(int)preset channel:(int)channel;
@end

@interface ELMIDIController : NSObject {
  id                    delegate;
  
  PYMIDIVirtualSource   *source;
  
  // CFStringRef     clientName;
  // CFStringRef     portName;
  // MIDIClientRef   midiClient;
  // MIDIEndpointRef source;
  // MIDIPortRef     outputPort;
  // MIDIEndpointRef destination;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (void)noteOn:(int)note velocity:(int)velocity channel:(int)channel;
- (void)noteOff:(int)note velocity:(int)velocity channel:(int)channel;
- (void)programChange:(int)preset channel:(int)channel;
- (void)sendMessage:(Byte *)data length:(int)length;

@end
