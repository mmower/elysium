//
//  ELHexStartInspectorPlugin.m
//  Elysium
//
//  Created by Matt Mower on 11/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexStartInspectorPlugin.h"

#import "ELHex.h"

@implementation ELHexStartInspectorPlugin

- (id)init {
  if( ( self = [super initWithLabel:@"Info" nibName:@"HexStartInspector.nib"] ) ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELHex class];
}

- (id)narrowInspectionFocus:(id)_object_ {
  return [_object_ toolOfType:@"start"];
}

@end
