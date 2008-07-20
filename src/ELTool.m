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
#import "ELPlayhead.h"

@implementation ELTool

- (id)initWithType:(NSString *)_type layer:(ELLayer *)_layer hex:(ELHex *)_hex config:(NSMutableDictionary *)_config {
  if( self = [super init] ) {
    type   = _type;
    layer  = _layer;
    hex    = _hex;
    config = _config;
  }
  
  return self;
}

// Tool specific invocation goes here
- (void)run:(ELPlayhead *)playhead {
}

@end
