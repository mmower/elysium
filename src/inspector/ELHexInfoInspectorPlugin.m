//
//  ELHexinfoInspectorPlugin.m
//  Elysium
//
//  Created by Matt Mower on 10/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexinfoInspectorPlugin.h"

#import "ELInspectorPane.h"
#import "ELHex.h"

@implementation ELHexInfoInspectorPlugin

- (id)init {
  if( self = [super initWithLabel:@"Info" nibName:@"HexInfoInspector.nib"] ) {
  }
  
  return self;
}

- (Class)willInspect {
  return [ELHex class];
}

@end
