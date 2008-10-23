//
//  ELReboundTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
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

// Tool runner

- (void)run:(ELPlayhead *)_playhead_ {
  [_playhead_ setDirection:[directionKnob value]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [self setToolDrawColor:_attributes_];
  [[self hex] drawTriangleInDirection:[directionKnob value] withAttributes:_attributes_];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithDirectionKnob:[directionKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionKnob xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithDirectionKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    [self loadIsEnabled:_representation_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='direction']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      directionKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    } else {
      directionKnob = [[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N minimum:0 maximum:5 stepping:1];
    }
    
    [self loadScripts:_representation_];
  }
  
  return self;
}

@end
