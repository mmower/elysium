//
//  ELMIDITriggerArrayController.h
//  Elysium
//
//  Created by Matt Mower on 30/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELMIDITriggerArrayController : NSArrayController {
  ELPlayer *player;
}

@property (assign) ELPlayer *player;

@end
