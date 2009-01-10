//
//  ELMIDITrigger.h
//  Elysium
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELXmlData.h"

@class ELPlayer;
@class ELMIDIControlMessage;

@interface ELMIDITrigger : NSObject <ELXmlData> {
  ELPlayer  *player;
  int       channelMask;
  int       controller;
  ELScript  *callback;
}

- (id)initWithPlayer:(ELPlayer *)player channelMask:(Byte)channelMask controller:(Byte)controller callback:(ELScript *)callback;

@property ELPlayer *player;
@property int channelMask;
@property int controller;
@property (assign) ELScript *callback;

- (BOOL)handleMIDIControlMessage:(ELMIDIControlMessage *)controlMessage;

@end
