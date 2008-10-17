//
//  ELSpinTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSpinTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"
#import "ELGenerateTool.h"
#import "ELReboundTool.h"

static NSString * const toolType = @"spin";

@implementation ELSpinTool

- (id)initWithClockwiseKnob:(ELBooleanKnob *)_clockwiseKnob_ steppingKnob:(ELIntegerKnob *)_steppingKnob_ {
  if( ( self = [super init] ) ) {
    clockwiseKnob = _clockwiseKnob_;
    steppingKnob  = _steppingKnob_;
    [self setPreferredOrder:9];
  }
  
  return self;
}

- (id)init {
  return [self initWithClockwiseKnob:[[ELBooleanKnob alloc] initWithName:@"clockwise" booleanValue:YES]
                        steppingKnob:[[ELIntegerKnob alloc] initWithName:@"stepping" integerValue:1]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize clockwiseKnob;
@synthesize steppingKnob;

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"clockwiseKnob.value",@"steppingKnob.value",nil]];
  return keys;
}

// What happens when a playhead arrives

- (void)runTool:(ELPlayhead *)_playhead_ {
  ELTool<DirectedTool> *tool;
  
  if( [[_playhead_ position] reboundTool] ) {
    tool = [[_playhead_ position] reboundTool];
  } else if( [[_playhead_ position] generateTool] ) {
    tool = [[_playhead_ position] generateTool];
  } else {
    tool = nil;
  }
  
  if( [clockwiseKnob value] ) {
    [[tool directionKnob] setValue:(([[tool directionKnob] value]+[steppingKnob value]) % 6)];
  } else {
    [[tool directionKnob] setValue:(([[tool directionKnob] value]-[steppingKnob value]) % 6)];
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  [self setToolDrawColor:_attributes_];
  
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
  return [[[self class] allocWithZone:_zone_] initWithClockwiseKnob:[clockwiseKnob mutableCopy] steppingKnob:[steppingKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[clockwiseKnob xmlRepresentation]];
  [controlsElement addChild:[steppingKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithClockwiseKnob:nil steppingKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    [self loadIsEnabled:_representation_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='clockwise']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      clockwiseKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    } else {
      clockwiseKnob = [[ELBooleanKnob alloc] initWithName:@"clockwise" booleanValue:YES];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='stepping']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      steppingKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    } else {
      steppingKnob = [[ELIntegerKnob alloc] initWithName:@"stepping" integerValue:1];
    }
    
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
