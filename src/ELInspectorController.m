//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELTool.h"
#import "ELHex.h"
#import "ELLayer.h"

#import "ELBeatTool.h"
#import "ELStartTool.h"

NSString* const ELNotifyObjectSelectionDidChange = @"elysium.objectSelectionDidChange";

@implementation ELInspectorController

- (id)init {
  if( self = [super initWithWindowNibName:@"Inspector"] ) {
  }
  return self;
}

- (void)awakeFromNib {
  [inspectorPanel setFloatingPanel:YES];
  [inspectorPanel setBecomesKeyOnlyIfNeeded:YES];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)finalize {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super finalize];
}

- (void)windowDidLoad {
  NSLog( @"Nib file is loaded" );
}

- (void)windowWillClose {
  NSLog( @"window will close" );
}

- (void)inspectHex {
  [tabView selectTabViewItemWithIdentifier:@"hex"];
  ELHex *hex = focusedObject;
  
  ELTool *tool;
  
  // Start tool inspector
  tool = [hex toolOfType:@"start"];
  if( tool ) {
    [hexStartEnabled setState:YES];
    [hexStartDirection setIntValue:[[tool config] integerForKey:@"direction"] * 60];
    [hexStartDirection setEnabled:YES];
    [hexStartTTL setIntValue:[[tool config] integerForKey:@"ttl"]];
    [hexStartTTL setEnabled:YES];
  } else {
    [hexStartEnabled setState:NO];
    [hexStartDirection setIntValue:0];
    [hexStartDirection setEnabled:NO];
    [hexStartTTL setStringValue:@""];
    [hexStartTTL setEnabled:NO];
  }
  
  // Beat tool inspector
  tool = [hex toolOfType:@"beat"];
  if( tool ) {
    [hexBeatEnabled setState:YES];
    [hexBeatVelocity setIntValue:[[tool config] integerForKey:@"velocity"]];
    [hexBeatVelocity setEnabled:YES];
    [hexBeatDuration setFloatValue:[[tool config] floatForKey:@"duration"]];
    [hexBeatDuration setEnabled:YES];
  } else {
    [hexBeatEnabled setState:NO];
    [hexBeatVelocity setStringValue:@""];
    [hexBeatVelocity setEnabled:NO];
    [hexBeatDuration setStringValue:@""];
    [hexBeatDuration setEnabled:NO];
  }
  
  // Ricochet tool inspector
  tool = [hex toolOfType:@"ricochet"];
  if( tool ) {
    [hexRicochetEnabled setState:YES];
    [hexRicochetDirection setEnabled:YES];
  } else {
    [hexRicochetEnabled setState:NO];
    [hexRicochetDirection setEnabled:NO];
  }
  
  tool = [hex toolOfType:@"splitter"];
  if( tool ) {
    [hexSplitterEnabled setState:YES];
  } else {
    [hexSplitterEnabled setState:NO];
  }
}

- (IBAction)changedHexStartEnabled:(id)sender {
  ELHex *hex = (ELHex *)focusedObject;
  
  if( [sender state] ) {
    [hex addTool:[[ELStartTool alloc] initWithDirection:N TTL:5]];
  } else {
    [hex removeTool:@"start"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexBeatEnabled:(id)sender {
  ELHex *hex = (ELHex *)focusedObject;
  
  if( [sender state] ) {
    [hex addTool:[[ELBeatTool alloc] initWithDirection:N TTL:5]];
  } else {
    [hex removeTool:@"start"];
  }
  
  [self inspectHex];
}

- (IBAction)changedRicochetEnabled:(id)sender {
  
}

- (IBAction)changedSplitterEnabled:(id)sender {
  
}

- (void)inspectLayer {
  [tabView selectTabViewItemWithIdentifier:@"layer"];
}

- (void)selectionChanged:(NSNotification*)_notification
{
  focusedObject = [_notification object];
  if( [focusedObject isKindOfClass:[ELHex class]] ) {
    [self inspectHex];
  } else if( [focusedObject isKindOfClass:[ELLayer class]] ) {
    [self inspectLayer];
  } else {
    [tabView selectTabViewItemWithIdentifier:@"none"];
  }
}

@end
