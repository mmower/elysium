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

- (id)initWithBounceBackKnob:(ELBooleanKnob *)_bounceBackKnob_ {
  if( ( self = [super init] ) ) {
    [self setBounceBackKnob:_bounceBackKnob_];
  }
  
  return self;
}

- (id)init {
  return [self initWithBounceBackKnob:[[ELBooleanKnob alloc] initWithName:@"bounceBack" booleanValue:NO]];
}

- (NSString *)toolType {
  return toolType;
}

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setPosition:nil];
  for( int direction = N; direction <= NW; direction++ ) {
    if( ![bounceBackKnob value] && direction == INVERSE_DIRECTION( [_playhead_ direction] ) ) {
      continue;
    }
    
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:[hex neighbour:direction]
                                                  direction:direction
                                                        TTL:[_playhead_ TTL]]];
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
  return [[[self class] allocWithZone:_zone_] initWithBounceBackKnob:[[self bounceBackKnob] mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[bounceBackKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    [self loadIsEnabled:_representation_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='bounceBack']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      [self setBounceBackKnob:[[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_]]
    } else {
      [self setBounceBackKnob:[[ELBooleanKnob alloc] initWithName:@"bounceBack" booleanValue:NO]]
    }
    
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
