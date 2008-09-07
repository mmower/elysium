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
#import "ELPlayerInspectorPane.h"
#import "ELLayerInspectorPane.h"
#import "ELHexInfoInspectorPlugin.h"
#import "ELHexStartInspectorPlugin.h"
#import "ELHexBeatInspectorPane.h"
#import "ELHexRicochetInspectorPane.h"
#import "ELHexSinkInspectorPane.h"
#import "ELHexSplitterInspectorPane.h"
#import "ELHexRotorInspectorPane.h"

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

// Initialization

- (id)init {
  if( ( self = [super initWithWindowNibName:@"Inspector"] ) ) {
    playerPanes = [[NSMutableArray alloc] init];
    layerPanes  = [[NSMutableArray alloc] init];
    hexPanes    = [[NSMutableArray alloc] init];
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
  [self addInspectorPane:[[ELPlayerInspectorPane alloc] init]];
  
  [self addInspectorPane:[[ELLayerInspectorPane alloc] init]];
  
  [self addInspectorPane:[[ELHexInfoInspectorPlugin alloc] init]];
  [self addInspectorPane:[[ELHexStartInspectorPlugin alloc] init]];
  [self addInspectorPane:[[ELHexBeatInspectorPane alloc] init]];
  [self addInspectorPane:[[ELHexRicochetInspectorPane alloc] init]];
  [self addInspectorPane:[[ELHexSinkInspectorPane alloc] init]];
  [self addInspectorPane:[[ELHexSplitterInspectorPane alloc] init]];
  [self addInspectorPane:[[ELHexRotorInspectorPane alloc] init]];
}

// Properties

@synthesize focusedHex;
@synthesize focusedLayer;
@synthesize focusedPlayer;

// Pane support

- (void)addInspectorPane:(ELInspectorPane *)pane {
  NSMutableArray *inspectors;
  PAStackedListView *view;
  Class class = [pane willInspect];
  
  if( class == [ELPlayer class] ) {
    inspectors = playerPanes;
    view = playerInspectorView;
  } else if( class == [ELLayer class] ) {
    inspectors = layerPanes;
    view = layerInspectorView;
  } else if( class == [ELHex class] ) {
    inspectors = hexPanes;
    view = hexInspectorView;
  } else {
    NSAssert1( NO, @"No inspector type for class %@", class );
  }
  
  [inspectors addObject:pane];
  [view addStackingView:[pane paneView]];
}

- (void)finalize {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super finalize];
}

// Delegate callbacks (still needed?)

- (void)windowDidLoad {
}

- (void)windowWillClose {
}

// Focused and selection

- (void)focus:(id)_focusedObject_ {
  NSString *tab;
  
  if( [_focusedObject_ isKindOfClass:[ELHex class] ] ) {
    focusedHex = _focusedObject_;
    focusedLayer = [focusedHex layer];
    focusedPlayer = [focusedLayer player];
    tab = @"hex";
  } else if( [_focusedObject_ isKindOfClass:[ELLayer class]] ) {
    focusedHex = nil;
    focusedLayer = _focusedObject_;
    focusedPlayer = [focusedLayer player];
    tab = @"layer";
  } else if( [_focusedObject_ isKindOfClass:[ELPlayer class]] ) {
    focusedHex = nil;
    focusedLayer = nil;
    focusedPlayer = _focusedObject_;
    tab = @"player";
  } else {
    NSAssert2( NO, @"Focused on unknown object %@ <%@>", _focusedObject_, [_focusedObject_ className] );
  }
  
  NSLog( @"Focus on hex=%@, layer=%@, player=%@, tab=%@", focusedHex, focusedLayer, focusedPlayer, tab );
  
  [hexPanes makeObjectsPerformSelector:@selector(inspect:) withObject:focusedHex];
  [layerPanes makeObjectsPerformSelector:@selector(inspect:) withObject:focusedLayer];
  [playerPanes makeObjectsPerformSelector:@selector(inspect:) withObject:focusedPlayer];
  [tabView selectTabViewItemWithIdentifier:tab];
}

- (void)selectionChanged:(NSNotification*)_notification
{
  [self focus:[_notification object]];
}

@end
