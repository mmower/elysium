//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELPlayer.h"
#import "ELLayer.h"
#import "ELHex.h"

@implementation ELInspectorController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"ELInspector"] ) ) {
  }
  
  return self;
}

@synthesize modeView;
@synthesize tabView;

@synthesize player;
@synthesize layer;
@synthesize cell;

- (void)awakeFromNib {
  
  [[tabView tabViewItemAtIndex:0] setView:playerView];
  [[tabView tabViewItemAtIndex:1] setView:layerView];
  [[tabView tabViewItemAtIndex:2] setView:generatorView];
  [[tabView tabViewItemAtIndex:3] setView:noteView];
  [[tabView tabViewItemAtIndex:4] setView:reboundView];
  [[tabView tabViewItemAtIndex:5] setView:absorbView];
  [[tabView tabViewItemAtIndex:6] setView:splitView];
  [[tabView tabViewItemAtIndex:7] setView:spinView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)selectionChanged:(NSNotification *)notification {
  if( [[notification object] isKindOfClass:[ELPlayer class]] ) {
    [self playerSelected:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELLayer class]] ) {
    [self layerSelected:[notification object]];
  } else if( [[notification object] isKindOfClass:[ELHex class]] ) {
    [self cellSelected:[notification object]];
  }
}

- (void)playerSelected:(ELPlayer *)thePlayer {
  [self setPlayer:thePlayer];
  [self setLayer:nil];
  [self setCell:nil];
}

- (void)layerSelected:(ELLayer *)theLayer {
  [self setPlayer:[theLayer player]];
  [self setLayer:theLayer];
  [self setCell:nil];
}

- (void)cellSelected:(ELHex *)theCell {
  [self setPlayer:[[theCell layer] player]];
  [self setLayer:[theCell layer]];
  [self setCell:theCell];
}

- (IBAction)selectTab:(id)sender {
  [tabView selectTabViewItemAtIndex:[sender selectedSegment]];
}

@end
