//
//  ELMIDITrigger.h
//  Elysium
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELXmlData.h"

@class RubyBlock;
@class ELMIDIControlMessage;

@interface ELMIDITrigger : NSObject <ELXmlData> {
  Byte      channelMask;
  Byte      controller;
  RubyBlock *callback;
}

- (id)initWithChannelMask:(Byte)channelMask controller:(Byte)controller callback:(RubyBlock *)callback;

@property Byte channelMask;
@property Byte controller;
@property (assign) RubyBlock *callback;

- (BOOL)handleControlMessage:(ELMIDIControlMessage *)controlMessage;

@end
