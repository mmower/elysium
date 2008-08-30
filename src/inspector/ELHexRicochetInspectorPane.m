//
//  ELHexRicochetInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 30/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexRicochetInspectorPane.h"

#import "ELHex.h"
#import "ELRicochetTool.h"

@implementation ELHexRicochetInspectorPane

- (id)init {
  if( self = [super initWithLabel:@"Ricochet" nibName:@"HexRicochetInspector.nib"] ) {
  }
  
  return self;
}

- (BOOL)willInspect:(Class)class {
  return class == [ELHex class];
}

- (ELRicochetTool *)tool {
  return (ELRicochetTool *)[inspectee toolOfType:@"ricochet"];
}

// Proxy methods for bindings

- (BOOL)toolEnabled {
  return [[self tool] enabled];
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

// Update our custom bindings
- (void)updateBindings {
  [self willChangeValueForKey:@"toolEnabled"];
  [self didChangeValueForKey:@"toolEnabled"];
  
  [self willChangeValueForKey:@"toolDirection"];
  [self didChangeValueForKey:@"toolDirection"];
}

@end
