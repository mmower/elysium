//
//  ELHexStartInspectorPlugin.m
//  Elysium
//
//  Created by Matt Mower on 11/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexStartInspectorPlugin.h"

#import "ELHex.h"

#import "ELStartTool.h"

@implementation ELHexStartInspectorPlugin

- (id)init {
  if( self = [super initWithLabel:@"Info" nibName:@"HexStartInspector.nib"] ) {
  }
  
  return self;
}

- (BOOL)willInspect:(Class)class {
  return class == [ELHex class];
}

- (ELStartTool *)tool {
  return (ELStartTool *)[inspectee toolOfType:@"start"];
}

// Proxy methods for bindings
- (BOOL)toolEnabled {
  return [self tool] != nil;
}

- (void)setToolEnabled:(BOOL)_enabled_ {
  [[self tool] setEnabled:_enabled_];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

- (float)toolDirection {
  return [[self tool] direction] * 60.0;
}

- (void)setToolDirection:(float)_direction_ {
  [[self tool] setDirection:(_direction_ / 60.0)];

  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

- (int)toolTTL {
  return [[self tool] TTL];
}

- (void)setToolTTL:(int)_ttl_ {
  [[self tool] setTTL:_ttl_];

  [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyCellWasUpdated object:[[self tool] hex]];
}

// Update our custom bindings
- (void)updateBindings {
  [self willChangeValueForKey:@"toolEnabled"];
  [self didChangeValueForKey:@"toolEnabled"];
  
  [self willChangeValueForKey:@"toolDirection"];
  [self didChangeValueForKey:@"toolDirection"];

  [self willChangeValueForKey:@"toolTTL"];
  [self didChangeValueForKey:@"toolTTL"];
}

@end
