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

- (Class)willInspect {
  return [ELHex class];
}

- (id)narrowInspectionFocus:(id)_object_ {
  return [_object_ toolOfType:@"ricochet"];
}

@end
