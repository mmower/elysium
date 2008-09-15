//
//  ELRotorTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRotorTool.h"

#import "ELHex.h"
#import "ELConfig.h"
#import "ELPlayhead.h"
#import "ELStartTool.h"
#import "ELRicochetTool.h"

@implementation ELRotorTool

- (id)initWithClockwiseKnob:(ELBooleanKnob *)_clockwiseKnob_ {
  if( ( self = [self initWithType:@"rotor"] ) ) {
    clockwiseKnob = _clockwiseKnob_;
  }
  
  return self;
}

- (id)init {
  if( ( self = [self initWithType:@"rotor"] ) ) {
    clockwiseKnob = [[ELBooleanKnob alloc] initWithName:@"clockwise" booleanValue:YES];
    [self setPreferredOrder:9];
  }
  
  return self;
}

@synthesize clockwiseKnob;

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"clockwiseKnob.value",nil]];
  return keys;
}

// What happens when a playhead arrives

- (BOOL)run:(ELPlayhead *)_playhead_ {
  if( [super run:_playhead_] ) {
    ELTool<DirectedTool> *tool;
    
    if( [[_playhead_ position] toolOfType:@"ricochet"] ) {
      tool = [[_playhead_ position] toolOfType:@"ricochet"];
    } else if( [[_playhead_ position] toolOfType:@"start"] ) {
      tool = [[_playhead_ position] toolOfType:@"start"];
    } else {
      tool = nil;
    }
    
    if( [clockwiseKnob value] ) {
      [[tool directionKnob] setValue:(([[tool directionKnob] value]+1) % 6)];
    } else {
      [[tool directionKnob] setValue:(([[tool directionKnob] value]-1) % 6)];
    }

    return YES;
  } else {
    return NO;
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];

  [[_attributes_ objectForKey:ELDefaultToolColor] set];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  
  if( [clockwiseKnob value] ) {
    [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3 - radius/10, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3 + radius/10, centre.y - radius/8 )];
    
    [symbolPath moveToPoint:NSMakePoint( centre.x + radius/3 - radius/10, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3 + radius/10, centre.y + radius/8 )];
  } else {
    [symbolPath moveToPoint:NSMakePoint( centre.x - radius/3 - radius/10, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x - radius/3 + radius/10, centre.y + radius/8 )];
    
    [symbolPath moveToPoint:NSMakePoint( centre.x + radius/3 - radius/10, centre.y - radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3, centre.y + radius/8 )];
    [symbolPath lineToPoint:NSMakePoint( centre.x + radius/3 + radius/10, centre.y - radius/8 )];
  }
  
  [symbolPath setLineWidth:2.0];
  [symbolPath stroke];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithClockwiseKnob:[clockwiseKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *rotorElement = [NSXMLNode elementWithName:@"rotor"];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[clockwiseKnob xmlRepresentation]];
  [rotorElement addChild:controlsElement];
  
  return rotorElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ {
  return nil;
}

@end
