//
//  ELMIDIController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <CoreMIDI/CoreMIDI.h>

@class ELMIDIMessage;
@class PYMIDIVirtualSource;

@interface ELMIDIController : NSObject {
  PYMIDIVirtualSource   *source;
}

- (ELMIDIMessage *)createMessage;
- (void)sendPackets:(MIDIPacketList *)packetList;

@end
