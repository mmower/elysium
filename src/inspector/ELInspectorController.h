//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELLayer;
@class ELPlayer;

@class ELInspectorPane;
@class PAStackedListView;

extern NSString* const ELNotifyObjectSelectionDidChange;

@interface ELInspectorController : NSWindowController {
  IBOutlet NSPanel            *inspectorPanel;
  IBOutlet NSTabView          *tabView;
  
  IBOutlet PAStackedListView  *hexInspectorView;
  IBOutlet PAStackedListView  *playerInspectorView;
  
  NSMutableArray              *playerPanes;
  NSMutableArray              *hexPanes;
  
  ELHex                       *focusedHex;
  ELPlayer                    *focusedPlayer;
}

@property (readonly) ELHex *focusedHex;
@property (readonly) ELPlayer *focusedPlayer;

- (void)loadPlugins;
- (void)addInspectorPane:(ELInspectorPane *)pane;

- (void)selectionChanged:(NSNotification*)notification;
- (void)focus:(id)focusedObject;

@end
