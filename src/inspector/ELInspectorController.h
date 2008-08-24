//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELConfig;
@class ELInspectorPane;
@class PAStackedListView;

extern NSString* const ELNotifyObjectSelectionDidChange;

@interface ELInspectorController : NSWindowController {
  IBOutlet NSPanel            *inspectorPanel;
  IBOutlet NSTabView          *tabView;
  
  IBOutlet PAStackedListView  *hexInspectorView;
  IBOutlet PAStackedListView  *layerInspectorView;
  IBOutlet PAStackedListView  *playerInspectorView;
  
  NSMutableArray              *inspectorPanes;
  id                          focusedObject;
}

- (void)selectionChanged:(NSNotification*)notification;

// - (void)inspectHex;
// - (void)inspectLayer;

- (ELHex *)focusedHex;

- (void)loadPlugins;
- (void)addInspectorPane:(ELInspectorPane *)pane;
- (void)focus:(id)focusedObject;

@end
