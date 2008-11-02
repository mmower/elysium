//
//  ELScriptPackageController.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELScriptPackageController : NSWindowController {
  ELPlayer *player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property (assign) ELPlayer *player;

@end
