//
//  ELPlayerInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 03/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELPlayerInspectorPane.h"

#import "ELInspectorPane.h"

#import "ELPlayer.h"

@implementation ELPlayerInspectorPane

- (id)init {
  if( self = [super initWithLabel:@"Player" nibName:@"PlayerInspector.nib"] ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELPlayer class];
}

@end
