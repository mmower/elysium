//
//  ELHexBeatInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 30/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexBeatInspectorPane.h"

#import "ELHex.h"

@implementation ELHexBeatInspectorPane

- (id)init {
  if( ( self = [super initWithLabel:@"Beat" nibName:@"HexBeatInspector.nib"] ) ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELHex class];
}

- (id)narrowInspectionFocus:(id)_object_ {
  return [_object_ toolOfType:@"beat"];
}

@end
