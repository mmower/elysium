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
  }
  
  return self;
}

- (id)init {
  return [self initWithClockwiseKnob:[[ELBooleanKnob alloc] initWithName:@"clockwise" booleanValue:YES]
                        steppingKnob:[[ELIntegerKnob alloc] initWithName:@"stepping" integerValue:1 minimum:0 maximum:5 stepping:1]];
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

- (void)start {
  [super start];
  
  [clockwiseKnob start];
  [steppingKnob start];
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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='clockwise']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        clockwiseKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        clockwiseKnob = [[ELBooleanKnob alloc] initWithName:@"clockwise" booleanValue:YES];
      }
      
      if( clockwiseKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='stepping']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        steppingKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        steppingKnob = [[ELIntegerKnob alloc] initWithName:@"stepping" integerValue:1 minimum:0 maximum:5 stepping:1];
      }
      
      if( steppingKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
  }
  
  return self;
}

@end
