//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELKey.h"
#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"

@implementation ELInspectorController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"ELInspector"] ) ) {
  }
  
  return self;
}

- (void)windowDidLoad {
  
}

@synthesize modeView;
@synthesize tabView;

@dynamic player;

- (ELPlayer *)player {
  return player;
}

- (void)setPlayer:(ELPlayer *)newPlayer {
  if( newPlayer != player ) {
    [playerController unbind:@"contentObject"];
    player = newPlayer;
    if( player ) {
      [playerController bind:@"contentObject" toObject:self withKeyPath:@"player" options:nil];
    }
  }
}

@dynamic layer;

- (ELLayer *)layer {
  return layer;
}

- (void)setLayer:(ELLayer *)newLayer {
  if( newLayer != layer ) {
    [layerController unbind:@"contentObject"];
    layer = newLayer;
    if( layer ) {
      [layerController bind:@"contentObject" toObject:self withKeyPath:@"layer" options:nil];
    }
  }
}

@synthesize cell;

- (ELHex *)cell {
  return cell;
}

- (void)setCell:(ELHex *)newCell {
  if( newCell != cell ) {
    [cellController unbind:@"contentObject"];
    cell = newCell;
    if( cell ) {
      [cellController bind:@"contentObject" toObject:self withKeyPath:@"cell" options:nil];
    }
  }
}

@synthesize title;

- (void)awakeFromNib {
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

- (void)playerSelected:(ELPlayer *)newPlayer {
  [self setPlayer:newPlayer];
  [self setLayer:nil];
  [self setCell:nil];
  
  [modeView setSelectedSegment:0];
  [tabView selectTabViewItemAtIndex:0];
}

- (void)layerSelected:(ELLayer *)newLayer {
  [self setPlayer:[newLayer player]];
  [self setLayer:newLayer];
  [self setCell:nil];
  
  [modeView setSelectedSegment:1];
  [tabView selectTabViewItemAtIndex:1];
}

- (void)cellSelected:(ELHex *)newCell {
  [self setPlayer:[[newCell layer] player]];
  [self setLayer:[newCell layer]];
  [self setCell:newCell];
}

- (IBAction)selectTab:(id)sender {
  int tab = [sender selectedSegment];
  
  [self setTitle:[[tabView tabViewItemAtIndex:tab] label]];
  [tabView selectTabViewItemAtIndex:tab];
}

- (NSArray *)keySignatures {
  return [ELKey allKeys];
}

@end
