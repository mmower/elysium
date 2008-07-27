//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELInspectorController : NSWindowController {
  IBOutlet NSPanel *inspectorPanel;
}

- (void)selectionChanged:(NSNotification*)notification;

@end
