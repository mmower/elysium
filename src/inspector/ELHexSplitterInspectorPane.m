//
//  ELHexSplitterInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 04/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexSplitterInspectorPane.h"

#import "ELHex.h"

@implementation ELHexSplitterInspectorPane

- (id)init {
  if( self = [super initWithLabel:@"Beat" nibName:@"HexSplitterInspector.nib"] ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELHex class];
}

- (id)narrowInspectionFocus:(id)_object_ {
  return [_object_ toolOfType:@"splitter"];
}

@end
