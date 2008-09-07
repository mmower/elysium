//
//  ELLayerInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 04/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELLayerInspectorPane.h"

#import "ELLayer.h"

@implementation ELLayerInspectorPane

- (id)init {
  if( ( self = [super initWithLabel:@"Layer" nibName:@"LayerInspector.nib"] ) ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELLayer class];
}
@end
