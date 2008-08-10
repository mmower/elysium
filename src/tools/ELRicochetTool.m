//
//  ELRicochetTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRicochetTool.h"

@implementation ELRicochetTool

- (id)init {
  if( self = [super initWithType:@"ricochet"] ) {
    [self setDirection:N];
  }

  return self;
}

- (id)initWithDirection:(Direction)_direction {
  if( self = [super initWithType:@"ricochet"] ) {
    [self setDirection:_direction];
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

// Tool runner

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [_playhead setDirection:[self direction]];
}

@end
