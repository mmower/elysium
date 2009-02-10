//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELInspectorViewController.h"
#import "ELPlayerInspectorViewController.h"
#import "ELLayerInspectorViewController.h"
#import "ELGenerateInspectorViewController.h"
#import "ELNoteInspectorViewController.h"
#import "ELReboundInspectorViewController.h"
#import "ELAbsorbInspectorViewController.h"
#import "ELSplitInspectorViewController.h"
#import "ELSpinInspectorViewController.h"

#import "ELDial.h"

#import "ELKey.h"
#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"

#import "ELOscillatorDesignerController.h"

@implementation ELInspectorController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"ELInspector"] ) ) {
    playerViewController   = [[ELPlayerInspectorViewController alloc] initWithInspectorController:self];
    layerViewController    = [[ELLayerInspectorViewController alloc] initWithInspectorController:self];
    generateViewController = [[ELGenerateInspectorViewController alloc] initWithInspectorController:self];
    noteViewController     = [[ELNoteInspectorViewController alloc] initWithInspectorController:self];
    reboundViewController  = [[ELReboundInspectorViewController alloc] initWithInspectorController:self];
    absorbViewController   = [[ELAbsorbInspectorViewController alloc] initWithInspectorController:self];
    splitViewController    = [[ELSplitInspectorViewController alloc] initWithInspectorController:self];
    spinViewController     = [[ELSpinInspectorViewController alloc] initWithInspectorController:self];
  }
  
  return self;
}

@synthesize modeView;
@synthesize tabView;

@synthesize player;
@synthesize layer;
@synthesize cell;

// - (ELHex *)cell {
//   return cell;
// }
// 
// - (void)setCell:(ELHex *)newCell {
//   if( newCell != cell ) {
//     [cellController unbind:@"contentObject"];
//     cell = newCell;
//     if( cell ) {
//       [cellController bind:@"contentObject" toObject:self withKeyPath:@"cell" options:nil];
//     }
//   }
// }

@synthesize title;

- (void)windowDidLoad {
  [panel setFloatingPanel:YES];
  // [panel setBecomesKeyOnlyIfNeeded:YES];
}

- (void)awakeFromNib {
  [[tabView tabViewItemAtIndex:0] setView:[playerViewController view]];
  [[tabView tabViewItemAtIndex:1] setView:[layerViewController view]];
  [[tabView tabViewItemAtIndex:2] setView:[generateViewController view]];
  [[tabView tabViewItemAtIndex:3] setView:[noteViewController view]];
  [[tabView tabViewItemAtIndex:4] setView:[reboundViewController view]];
  [[tabView tabViewItemAtIndex:5] setView:[absorbViewController view]];
  [[tabView tabViewItemAtIndex:6] setView:[splitViewController view]];
  [[tabView tabViewItemAtIndex:7] setView:[spinViewController view]];
  
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

- (IBAction)editOscillator:(ELDial *)dial {
  ELOscillatorDesignerController *controller;
  
  controller = [oscillatorEditors objectForKey:dial];
  if( controller == nil ) {
    controller = [[ELOscillatorDesignerController alloc] initWithDial:dial controller:self];
    [oscillatorEditors setObject:controller forKey:dial];
  }
  
  [controller edit];
}

- (void)finishedEditingOscillatorForDial:(ELDial *)dial {
  [oscillatorEditors removeObjectForKey:dial];
}

@end
