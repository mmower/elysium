//
//  ELRicochetTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRicochetTool.h"

#import "ELHex.h"

@implementation ELRicochetTool

- (id)init {
  if( ( self = [super initWithType:@"ricochet"] ) ) {
    [self setDirection:N];
  }

  return self;
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"direction",nil]];
  return keys;
}


@dynamic direction;

- (Direction)direction {
  return [config integerForKey:@"direction"];
}

- (void)setDirection:(Direction)_direction {
  [config setInteger:_direction forKey:@"direction"];
}

// Tool runner

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [_playhead setDirection:[self direction]];
    return YES;
  } else {
    return NO;
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [[self hex] drawTriangleInDirection:[self direction] withAttributes:_attributes_];
}

@end
