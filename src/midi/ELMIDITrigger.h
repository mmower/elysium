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

@class ELPlayer;
@class ELMIDIControlMessage;

@interface ELMIDITrigger : NSObject <ELXmlData> {
  ELPlayer  *player;
  int       channelMask;
  int       controller;
  RubyBlock *callback;
}

- (id)initWithPlayer:(ELPlayer *)player channelMask:(Byte)channelMask controller:(Byte)controller callback:(RubyBlock *)callback;

@property ELPlayer *player;
@property int channelMask;
@property int controller;
@property (assign) RubyBlock *callback;

- (BOOL)handleMIDIControlMessage:(ELMIDIControlMessage *)controlMessage;

@end
