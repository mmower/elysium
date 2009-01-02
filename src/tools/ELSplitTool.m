//
//  ELSplitTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSplitTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"split";

@implementation ELSplitTool

- (id)initWithBounceBackKnob:(ELBooleanKnob *)_bounceBackKnob_ {
  if( ( self = [super init] ) ) {
    bounceBackKnob = _bounceBackKnob_;
  }
  
  return self;
}

- (id)init {
  return [self initWithBounceBackKnob:[[ELBooleanKnob alloc] initWithName:@"bounceBack" booleanValue:NO]];
}

@synthesize bounceBackKnob;

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"bounceBackKnob.value",nil]];
  return keys;
}

- (NSString *)toolType {
  return toolType;
}

- (void)start {
  [super start];
  
  [bounceBackKnob start];
}

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setPosition:nil];
  
  BOOL bounceBack = ![bounceBackKnob value];
  int bounceBackDirection = INVERSE_DIRECTION( [_playhead_ direction] );
  
  for( int direction = N; direction <= NW; direction++ ) {
    if( bounceBack && ( direction == bounceBackDirection ) ) {
      continue;
    }
    
    [layer queuePlayhead:[[ELPlayhead alloc] initWithPosition:hex
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
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setBounceBackKnob:[[self bounceBackKnob] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[bounceBackKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_player_ player:_player_ error:_error_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='bounceBack']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        bounceBackKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        bounceBackKnob = [[ELBooleanKnob alloc] initWithName:@"bounceBack" booleanValue:NO];
      }
      
      if( bounceBackKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
  }
  
  return self;
}

@end
