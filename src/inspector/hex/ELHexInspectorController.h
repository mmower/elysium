//
//  ELHexInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;

@interface ELHexInspectorController : NSWindowController {
  ELHex *hex;
}

@property ELHex *hex;

- (void)focus:(ELHex *)hex;
- (void)selectionChanged:(NSNotification*)notification;

@end
