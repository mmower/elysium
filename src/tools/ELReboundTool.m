//
//  ELReboundTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELReboundTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"rebound";

@implementation ELReboundTool

- (id)initWithDirectionKnob:(ELIntegerKnob *)_directionKnob_ {
  if( ( self = [super init] ) ) {
    directionKnob = _directionKnob_;
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionKnob:[[ELIntegerKnob alloc] initWithName:@"direction"
                                                            integerValue:N
                                                            minimum:0
                                                            maximum:5
                                                            stepping:1]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize directionKnob;

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionKnob.value",nil]];
  return keys;
}

- (void)start {
  [super start];
  
  [directionKnob start];
}

// Tool runner

- (void)runTool:(ELPlayhead *)_playhead_ {
  [_playhead_ setDirection:[directionKnob value]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [self setToolDrawColor:_attributes_];
  [[self hex] drawTriangleInDirection:[directionKnob value] withAttributes:_attributes_];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setDirectionKnob:[[self directionKnob] mutableCopy]];
  return copy;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='direction']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        directionKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        directionKnob = [[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N minimum:0 maximum:5 stepping:1];
      }
      [directionKnob setMinimum:0 maximum:5 stepping:1];
      
      if( directionKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
  }
  
  return self;
}

@end
