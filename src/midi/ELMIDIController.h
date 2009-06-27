//
//  ELMIDIController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

@class ELMIDIMessage;
@class PYMIDIEndpoint;
@class PYMIDIVirtualSource;

@interface ELMIDIController : NSObject {
  PYMIDIVirtualSource       *_source;
  PYMIDIEndpoint            *_endpoint;
  
  id                        _delegate;
}

@property (assign) id delegate;

+ (ELMIDIController *)sharedInstance;

- (ELMIDIMessage *)createMessage;
- (void)sendPackets:(MIDIPacketList *)packetList;

- (void)setInput:(PYMIDIEndpoint *)endpoint;

- (void)processMIDIPacketList:(MIDIPacketList*)packetList sender:(id)sender;
- (void)handleMIDIMessage:(Byte*)message ofSize:(int)size;

@end
