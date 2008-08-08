//
//  ELStartTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELStartTool.h"

#import "ELConfig.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELStartTool

- (id)initWithDirection:(Direction)_direction TTL:(int)_ttl {
  if( self = [super initWithType:@"start"] ) {
    [self setDirection:_direction];
    [self setTTL:_ttl];
  }

  return self;
}

@dynamic direction;

- (Direction)direction {
  return [config integerForKey:@"direction"];
}

- (void)setDirection:(Direction)_direction {
  [config setInteger:_direction forKey:@"direction"];
}

@dynamic TTL;

- (int)TTL {
  return [config integerForKey:@"ttl"];
}

- (void)setTTL:(int)_ttl {
  [config setInteger:_ttl forKey:@"ttl"];
}

// Tool runner

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                direction:[self direction]
                                                      ttl:[self TTL]]];
}

@end
