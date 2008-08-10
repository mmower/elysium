//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

#import "ELConfig.h"
#import "ELTool.h"
#import "ELHex.h"
#import "ELLayer.h"

#import "ELBeatTool.h"
#import "ELSinkTool.h"
#import "ELStartTool.h"
#import "ELRotorTool.h"
#import "ELSplitterTool.h"
#import "ELRicochetTool.h"

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

- (ELHex *)focusedHex {
  return (ELHex *)focusedObject;
}

- (void)setIntField:(NSTextField *)input config:(ELConfig *)config key:(NSString *)key {
  if( [config inheritsValueForKey:key] ) {
    [[input cell] setPlaceholderString:[[config parent] stringForKey:key]];
  } else {
    [[input cell] setPlaceholderString:[[config parent] stringForKey:@""]];
  }
  
  if( [config definesValueForKey:key] ) {
    [input setIntValue:[config integerForKey:key]];
  } else {
    [input setStringValue:@""];
  }
  [input setEnabled:YES];
}

- (void)setFloatField:(NSTextField *)input config:(ELConfig *)config key:(NSString *)key {
  if( [config inheritsValueForKey:key] ) {
    [[input cell] setPlaceholderString:[[config parent] stringForKey:key]];
  } else {
    [[input cell] setPlaceholderString:[[config parent] stringForKey:@""]];
  }
  
  if( [config definesValueForKey:key] ) {
    [input setFloatValue:[config integerForKey:key]];
  } else {
    [input setStringValue:@""];
  }
  [input setEnabled:YES];
}

- (void)inspectHex {
  [tabView selectTabViewItemWithIdentifier:@"hex"];
  ELHex *hex = [self focusedHex];
  
  ELTool *tool;
  
  [hexColumn setIntValue:[hex column]];
  [hexRow setIntValue:[hex row]];
  [hexNote setStringValue:[[hex note] name]];
  
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
    [self setIntField:hexBeatVelocity config:[tool config] key:@"velocity"];
    [self setFloatField:hexBeatDuration config:[tool config] key:@"duration"];
  } else {
    [hexBeatEnabled setState:NO];
    [hexBeatVelocity setStringValue:@""];
    [[hexBeatVelocity cell] setPlaceholderString:@""];
    [hexBeatVelocity setEnabled:NO];
    [hexBeatDuration setStringValue:@""];
    [hexBeatDuration setEnabled:NO];
  }
  
  // Ricochet tool inspector
  [hexRicochetEnabled setState:[hex hasToolOfType:@"ricochet"]];
  [hexRicochetDirection setEnabled:[hex hasToolOfType:@"ricochet"]];
  
  [hexSplitterEnabled setState:[hex hasToolOfType:@"splitter"]];
  [hexSinkEnabled setState:[hex hasToolOfType:@"sink"]];
  [hexRotorEnabled setState:[hex hasToolOfType:@"rotor"]];
}

- (IBAction)changedHexStartEnabled:(id)sender {
  if( [sender state] ) {
    [[self focusedHex] addTool:[[ELStartTool alloc] initWithDirection:N TTL:25]];
  } else {
    [[self focusedHex] removeTool:@"start"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexStartDirection:(id)sender {
  [(ELStartTool *)[[self focusedHex] toolOfType:@"start"] setDirection:[sender intValue]/60];
}

- (IBAction)changedHexStartTTL:(id)sender {
  ELStartTool *tool = (ELStartTool*)[[self focusedHex] toolOfType:@"start"];
  
  if( [[sender stringValue] isEqualToString:@""] ) {
    [tool useInheritedConfig:@"ttl"];
  } else {
    [tool setTTL:[sender intValue]];
  }
  
  [self inspectHex];
}

- (IBAction)resetHexStartTTL:(id)sender {
  [[[[self focusedHex] toolOfType:@"start"] config] removeValueForKey:@"ttl"];
  [self inspectHex];
}

- (IBAction)changedHexBeatEnabled:(id)sender {
  if( [sender state] ) {
    [[self focusedHex] addTool:[[ELBeatTool alloc] init]];
  } else {
    [[self focusedHex] removeTool:@"beat"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexBeatVelocity:(id)sender {
  ELBeatTool *tool = (ELBeatTool*)[[self focusedHex] toolOfType:@"beat"];
  
  if( [[sender stringValue] isEqualToString:@""] ) {
    [tool useInheritedConfig:@"velocity"];
  } else {
    [tool setVelocity:[sender intValue]];
  }
  
  [self inspectHex];
}

- (IBAction)resetHexBeatVelocity:(id)sender {
  [[[[self focusedHex] toolOfType:@"beat"] config] removeValueForKey:@"velocity"];
  [self inspectHex];
}

- (IBAction)changedHexBeatDuration:(id)sender {
  ELBeatTool *tool = (ELBeatTool*)[[self focusedHex] toolOfType:@"beat"];
  
  if( [[sender stringValue] isEqualToString:@""] ) {
    [tool useInheritedConfig:@"duration"];
  } else {
    [tool setDuration:[sender floatValue]];
  }
  
  [self inspectHex];
}

- (IBAction)resetHexBeatDuration:(id)sender {
  [[[[self focusedHex] toolOfType:@"beat"] config] removeValueForKey:@"duration"];
  [self inspectHex];
}

- (IBAction)changedHexRicochetEnabled:(id)sender {
  if( [sender state] ) {
    [[self focusedHex] addTool:[[ELRicochetTool alloc] initWithDirection:N]];
  } else {
    [[self focusedHex] removeTool:@"beat"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexRicochetDirection:(id)sender {
  [(ELRicochetTool *)[[self focusedHex] toolOfType:@"ricochet"] setDirection:[sender intValue]/60];
}


- (IBAction)changedHexSplitterEnabled:(id)sender {
  ELHex *hex = (ELHex *)focusedObject;
  
  if( [sender state] ) {
    [hex addTool:[ELSplitterTool new]];
  } else {
    [hex removeTool:@"splitter"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexSinkEnabled:(id)sender {
  if( [sender state] ) {
    [[self focusedHex] addTool:[ELSinkTool new]];
  } else {
    [[self focusedHex] removeTool:@"sink"];
  }
  
  [self inspectHex];
}

- (IBAction)changedHexRotorEnabled:(id)sender {
  if( [sender state] ) {
    [[self focusedHex] addTool:[ELRotorTool new]];
  } else {
    [[self focusedHex] removeTool:@"rotor"];
  }
  
  [self inspectHex];
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
