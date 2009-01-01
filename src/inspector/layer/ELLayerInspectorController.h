//
//  ELLayerInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELLayer;

@interface ELLayerInspectorController : NSWindowController {
  ELLayer *layer;
}

@property ELLayer *layer;

- (void)focus:(ELLayer *)layer;
- (void)selectionChanged:(NSNotification*)notification;

- (IBAction)editOscillator:(id)sender;
- (IBAction)editScript:(id)sender;
- (IBAction)removeScript:(id)sender;

- (NSArray *)allKeys;

@end
