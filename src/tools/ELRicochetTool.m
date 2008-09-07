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
  // NSPoint centre = [[self hex] centre];
  // float radius = [[self hex] radius];
  // 
  // NSBezierPath *symbolPath = [NSBezierPath bezierPathWithRect:NSMakeRect( centre.x - 3 * radius / 8, centre.y - radius / 16, 3 * radius / 4, radius / 8 )];
  // if( [self direction] != 0 ) {
  //   NSAffineTransform *transform = [NSAffineTransform transform];
  //   [transform translateXBy:centre.x yBy:centre.y];
  //   [transform rotateByDegrees:(360.0 - ( [self direction] * 60 ))];
  //   [transform translateXBy:-centre.x yBy:-centre.y];
  //   [symbolPath transformUsingAffineTransform:transform];
  // }
  // 
  // [[_attributes_ objectForKey:ELToolColor] set];
  // [symbolPath setLineWidth:2.0];
  // [symbolPath stroke];
  // 
  [[self hex] drawTriangleInDirection:[self direction] withAttributes:_attributes_];
}

@end
