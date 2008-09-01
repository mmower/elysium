//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import <StackedListView/PAStackedListView.h>

#import "ELInspectorController.h"
#import "ELInspectorPane.h"
#import "ELHexBeatInspectorPane.h"
#import "ELHexInfoInspectorPlugin.h"
#import "ELHexStartInspectorPlugin.h"
#import "ELHexRicochetInspectorPane.h"

#import "ELConfig.h"
#import "ELTool.h"
#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"

#define PLAYER_TAB_ITEM_INDEX 0
#define LAYER_TAB_ITEM_INDEX 1
#define HEX_TAB_ITEM_INDEX 2

NSString* const ELNotifyObjectSelectionDidChange = @"elysium.objectSelectionDidChange";

@implementation ELInspectorController

- (id)init {
  if( self = [super initWithWindowNibName:@"Inspector"] ) {
    inspectorPanes = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)awakeFromNib {
  [inspectorPanel setFloatingPanel:YES];
  [inspectorPanel setBecomesKeyOnlyIfNeeded:YES];
  
  [self loadPlugins];
  
  [[tabView tabViewItemAtIndex:PLAYER_TAB_ITEM_INDEX] setView:playerInspectorView];
  [[tabView tabViewItemAtIndex:LAYER_TAB_ITEM_INDEX] setView:layerInspectorView];
  [[tabView tabViewItemAtIndex:HEX_TAB_ITEM_INDEX] setView:hexInspectorView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)loadPlugins {
  [self addInspectorPane:[[ELHexInfoInspectorPlugin alloc] init]];
  [self addInspectorPane:[[ELHexStartInspectorPlugin alloc] init]];
  [self addInspectorPane:[[ELHexBeatInspectorPane alloc] init]];
  [self addInspectorPane:[[ELHexRicochetInspectorPane alloc] init]];
}

- (void)addInspectorPane:(ELInspectorPane *)pane {
  [inspectorPanes addObject:pane];
  if( [pane willInspect:[ELHex class]] ) {
    [hexInspectorView addStackingView:[pane paneView]];
  } else if( [pane willInspect:[ELLayer class]] ) {
    [layerInspectorView addSubview:[pane paneView] positioned:NSWindowBelow relativeTo:nil];
  } else if( [pane willInspect:[ELPlayer class]] ) {
    [playerInspectorView addSubview:[pane paneView] positioned:NSWindowBelow relativeTo:nil];
  }
}

- (void)finalize {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super finalize];
}

- (void)windowDidLoad {
}

- (void)windowWillClose {
}

- (ELHex *)focusedHex {
  return (ELHex *)focusedObject;
}

- (void)inspectPlayer {
  [tabView selectTabViewItemWithIdentifier:@"player"];
}

- (void)inspectLayer {
  [tabView selectTabViewItemWithIdentifier:@"layer"];
}

- (void)inspectHex {
  [tabView selectTabViewItemWithIdentifier:@"hex"];
}

- (void)focus:(id)_focusedObject_ {
  for( ELInspectorPane *pane in inspectorPanes ) {
    if( [pane willInspect:[_focusedObject_ class]] ) {
      [pane inspect:_focusedObject_];
    }
  }
  
  if( [_focusedObject_ isKindOfClass:[ELHex class]] ) {
    [self inspectHex];
  } else if( [_focusedObject_ isKindOfClass:[ELLayer class]] ) {
    [self inspectLayer];
  } else {
    [self inspectPlayer];
  }
}

- (void)selectionChanged:(NSNotification*)_notification
{
  [self focus:[_notification object]];
}

@end
