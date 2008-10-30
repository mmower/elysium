//
//  ELMIDIControlMessage.h
//  Elysium
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELMIDIControlMessage : NSObject {
  Byte  channel;
  Byte  controller;
  Byte  value;
}

- (id)initWithChannel:(Byte)channel controller:(Byte)controller value:(Byte)value;

@property Byte channel;
@property Byte controller;
@property Byte value;

- (BOOL)matchesChannelMask:(Byte)channelMask andController:(Byte)controller;

@end
