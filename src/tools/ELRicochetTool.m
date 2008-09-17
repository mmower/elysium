//
//  ELRicochetTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRicochetTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"ricochet";

@implementation ELRicochetTool

+ (void)initialize {
  [ELTool addToolMapping:[ELRicochetTool class] forKey:toolType];
}

- (id)initWithDirectionKnob:(ELIntegerKnob *)_directionKnob_ {
  if( ( self = [super initWithType:toolType] ) ) {
    directionKnob = _directionKnob_;
  }
  
  return self;
}

- (id)init {
  if( ( self = [super initWithType:toolType] ) ) {
    directionKnob = [[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N];
  }

  return self;
}

@synthesize directionKnob;

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionKnob.value",nil]];
  return keys;
}

// Tool runner

- (BOOL)run:(ELPlayhead *)_playhead_ {
  if( [super run:_playhead_] ) {
    [_playhead_ setDirection:[directionKnob value]];
    return YES;
  } else {
    return NO;
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [[self hex] drawTriangleInDirection:[directionKnob value] withAttributes:_attributes_];
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithDirectionKnob:[directionKnob mutableCopy]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *ricochetElement = [NSXMLNode elementWithName:toolType];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[directionKnob xmlRepresentation]];
  [ricochetElement addChild:controlsElement];
  
  return ricochetElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ {
  if( ( self = [self initWithType:toolType] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='direction']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    directionKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element];
  }
  
  return self;
}

@end
