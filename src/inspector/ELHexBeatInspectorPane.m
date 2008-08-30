//
//  ELHexBeatInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 30/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexBeatInspectorPane.h"

#import "ELHex.h"
#import "ELBeatTool.h"

@implementation ELHexBeatInspectorPane

- (id)init {
  if( self = [super initWithLabel:@"Beat" nibName:@"HexBeatInspector.nib"] ) {
  }
  
  return self;
}

- (BOOL)willInspect:(Class)class {
  return class == [ELHex class];
}

- (ELBeatTool *)tool {
  return (ELBeatTool *)[inspectee toolOfType:@"beat"];
}

// Proxy methods for bindings

- (BOOL)toolEnabled {
  return [[self tool] enabled];
}

- (void)setToolEnabled:(BOOL)_enabled_ {
  [[self tool] setEnabled:_enabled_];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

- (int)toolVelocity {
  return [[self tool] velocity];
}

- (void)setToolVelocity:(int)_velocity_ {
  [[self tool] setVelocity:_velocity_];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

- (float)toolDuration {
  return [[self tool] duration];
}

- (void)setToolDuration:(float)_duration_ {
  [[self tool] setDuration:_duration_];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

// Update our custom bindings
- (void)updateBindings {
  [self willChangeValueForKey:@"toolEnabled"];
  [self didChangeValueForKey:@"toolEnabled"];
  
  [self willChangeValueForKey:@"toolVelocity"];
  [self didChangeValueForKey:@"toolVelocity"];

  [self willChangeValueForKey:@"toolDuration"];
  [self didChangeValueForKey:@"toolDuration"];
}

@end
