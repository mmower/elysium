//
//  ELGenerateTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELGenerateTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"generate";

@implementation ELGenerateTool

- (id)initWithDirectionKnob:(ELIntegerKnob *)_directionKnob_
             timeToLiveKnob:(ELIntegerKnob *)_timeToLiveKnob_
             pulseCountKnob:(ELIntegerKnob *)_pulseCountKnob_
             offsetKnob:(ELIntegerKnob *)_offsetKnob_ {
  if( ( self = [super init] ) ) {
    directionKnob = _directionKnob_;
    timeToLiveKnob = _timeToLiveKnob_;
    pulseCountKnob = _pulseCountKnob_;
    offsetKnob = _offsetKnob_;
    [self setPreferredOrder:1];
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionKnob:[[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N]
                      timeToLiveKnob:[[ELIntegerKnob alloc] initWithName:@"timeToLive"]
                      pulseCountKnob:[[ELIntegerKnob alloc] initWithName:@"pulseCount"]
                          offsetKnob:[[ELIntegerKnob alloc] initWithName:@"offset" integerValue:0]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize directionKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize offsetKnob;

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  [timeToLiveKnob setValue:[[_layer_ timeToLiveKnob] value]];
  [timeToLiveKnob setLinkedKnob:[_layer_ timeToLiveKnob]];
  [timeToLiveKnob setLinkValue:YES];
  
  [pulseCountKnob setValue:[[_layer_ pulseCountKnob] value]];
  [pulseCountKnob setLinkedKnob:[_layer_ pulseCountKnob]];
  [pulseCountKnob setLinkValue:YES];
  
  [_layer_ addGenerator:self];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [_layer_ removeGenerator:self];
  
  [timeToLiveKnob setLinkedKnob:nil];
  [pulseCountKnob setLinkedKnob:nil];
  
  [super removedFromLayer:_layer_];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionKnob.value",@"timeToLiveKnob.value",@"pulseCountKnob.value",@"offsetKnob.value",nil]];
  return keys;
}

// Tool runner

- (BOOL)shouldPulseOnBeat:(int)_beat_ {
  int pulseCount = [pulseCountKnob filteredValue];
  if( pulseCount < 1 ) {
    return NO;
  } else {
    return ( ( _beat_ - [offsetKnob filteredValue] ) % pulseCount ) == 0;
  }
}

- (void)runTool:(ELPlayhead *)_playhead_ {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[directionKnob value]
                                                        TTL:[timeToLiveKnob filteredValue]]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  NSBezierPath *symbolPath;
  symbolPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];

  [[_attributes_ objectForKey:ELDefaultToolColor] set];
  [symbolPath stroke];
  
  [[self hex] drawTriangleInDirection:[directionKnob value] withAttributes:_attributes_];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *generatorElement = [NSXMLNode elementWithName:toolType];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[directionKnob xmlRepresentation]];
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[offsetKnob xmlRepresentation]];
  [generatorElement addChild:controlsElement];
  
  return generatorElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithDirectionKnob:nil timeToLiveKnob:nil pulseCountKnob:nil offsetKnob:nil] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='direction']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    directionKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] timeToLiveKnob] player:_player_];

    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] pulseCountKnob] player:_player_];

    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='offset']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithDirectionKnob:[directionKnob mutableCopy]
                                                     timeToLiveKnob:[timeToLiveKnob mutableCopy]
                                                     pulseCountKnob:[pulseCountKnob mutableCopy]
                                                         offsetKnob:[offsetKnob mutableCopy]];
}

@end
