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

// Proxy methods for bindings
- (BOOL)toolEnabled {
  return [inspectee toolOfType:@"start"] != nil;
}

- (void)setToolEnabled:(BOOL)_enabled_ {
  NSLog( @"setToolEnabled:%@", _enabled_ ? @"YES" : @"NO" );
  if( _enabled_ ) {
    [inspectee addTool:[[ELStartTool alloc] initWithDirection:N TTL:25]];
  } else {
    [inspectee removeTool:@"start"];
  }
}

// Update our custom bindings
- (void)updateBindings {
  [self willChangeValueForKey:@"toolEnabled"];
  [self didChangeValueForKey:@"toolEnabled"];
}

@end
