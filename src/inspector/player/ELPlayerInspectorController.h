//
//  ELPlayerInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELPlayerInspectorController : NSWindowController {
  ELPlayer *player;
}

@property ELPlayer *player;

- (void)focus:(ELPlayer *)player;
- (void)selectionChanged:(NSNotification*)notification;

- (IBAction)editScript:(id)sender;
- (IBAction)removeScript:(id)sender;

@end
