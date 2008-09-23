//
//  ELFilterDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELFilterDesignerController : NSWindowController {
  ELPlayer *player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property (readonly) ELPlayer *player;

@end
