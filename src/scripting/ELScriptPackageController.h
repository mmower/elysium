//
//  ELScriptPackageController.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELScriptPackageController : NSWindowController {
  ELPlayer *player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property (assign) ELPlayer *player;

@end
