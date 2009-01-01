//
//  ELPlayerInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELPlayerInspectorController : NSWindowController {
  ELPlayer            *player;
  NSMutableDictionary *oscillatorDesigners;
}

@property ELPlayer *player;

- (void)focus:(ELPlayer *)player;
- (void)selectionChanged:(NSNotification*)notification;

- (IBAction)editOscillator:(id)sender;
- (IBAction)editScript:(id)sender;
- (IBAction)removeScript:(id)sender;

@end
