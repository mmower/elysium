//
//  ELSplitTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSplitTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"split";

@implementation ELSplitTool

- (NSString *)toolType {
  return toolType;
}

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setPosition:nil];
  for( int direction = N; direction <= NW; direction++ ) {
    if( direction != INVERSE_DIRECTION( [_playhead_ direction] ) ) {
      [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:[hex neighbour:direction]
                                                    direction:direction
                                                          TTL:[_playhead_ TTL]]];
    }
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];

  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3, centre.y )];
  [symbolPath lineToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y + radius/4 )];
  [symbolPath moveToPoint:centre];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y - radius/4 )];
  
  [self setToolDrawColor:_attributes_];
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] init];
}

// Implement the ELXmlData protocol

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    [self loadIsEnabled:_representation_];
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
