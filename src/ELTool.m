//
//  ELTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELConfig.h"
#import "ELPlayhead.h"

@implementation ELTool

- (id)initWithType:(NSString *)_type config:(ELConfig *)_config {
  if( self = [super init] ) {
    type   = _type;
    config = _config;
  }
  
  return self;
}

- (void)addedToLayer:(ELLayer *)_layer atPosition:(ELHex *)_hex {
  layer = _layer;
  hex   = _hex;
}

// Tool specific invocation goes here
- (void)run:(ELPlayhead *)playhead {
  NSLog( @"Tool of type %@ has been run at %@", type, hex );
}

@end
