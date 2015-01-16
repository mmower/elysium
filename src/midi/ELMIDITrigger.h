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
    ELPlayer *_player;
    int _channelMask;
    int _controller;
    ELScript *_callback;
}

- (id)initWithPlayer:(ELPlayer *)player channelMask:(Byte)channelMask controller:(Byte)controller callback:(ELScript *)callback;

@property (nonatomic, strong) ELPlayer *player;
@property  (nonatomic) int channelMask;
@property  (nonatomic) int controller;
@property (nonatomic, assign) ELScript *callback;

- (BOOL)handleMIDIControlMessage:(ELMIDIControlMessage *)controlMessage;

@end
