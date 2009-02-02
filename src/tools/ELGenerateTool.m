//
//  ELGenerateTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELGenerateTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

static NSString * const toolType = @"generate";

@implementation ELGenerateTool

- (id)initWithDirectionDial:(ELDial *)newDirectionDial
             timeToLiveDial:(ELDial *)newTimeToLiveDial
             pulseEveryDial:(ELDial *)newPulseEveryDial
                 offsetDial:(ELDial *)newOffsetDial
{
  if( ( self = [super init] ) ) {
    directionDial  = newDirectionDial;
    timeToLiveDial = newTimeToLiveDial;
    pulseEveryDial = newPulseEveryDial;
    offsetDial     = newOffsetDial;
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionDial:[[ELDial alloc] initWithName:@"direction" tag:0 assigned:N min:0 max:5 step:1]
                      timeToLiveDial:[ELPlayer defaultTimeToLiveDial]
                      pulseEveryDial:[ELPlayer defaultPulseEveryDial]
                          offsetDial:[[ELDial alloc] initWithName:@"offset" tag:0 assigned:0 min:0 max:64 step:1]];
}

- (NSString *)toolType {
  return toolType;
}

@synthesize directionDial;
@synthesize timeToLiveDial;
@synthesize pulseEveryDial;
@synthesize offsetDial;

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  if( !loaded ) {
    [timeToLiveDial setParent:[_layer_ timeToLiveDial]];
    [timeToLiveDial setMode:dialInherited];
    // [timeToLiveKnob setValue:[[_layer_ timeToLiveKnob] value]];
    // [timeToLiveKnob setLinkedKnob:[_layer_ timeToLiveKnob]];
    // [timeToLiveKnob setLinkValue:YES];
    
    [pulseEveryDial setParent:[_layer_ pulseEveryDial]];
    [pulseEveryDial setMode:dialInherited];
    // [pulseCountKnob setValue:[[_layer_ pulseCountKnob] value]];
    // [pulseCountKnob setLinkedKnob:[_layer_ pulseCountKnob]];
    // [pulseCountKnob setLinkValue:YES];
  }
  
  [_layer_ addGenerator:self];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [_layer_ removeGenerator:self];
  
  [timeToLiveDial setParent:nil];
  [pulseEveryDial setParent:nil];
  // 
  // [timeToLiveKnob setLinkedKnob:nil];
  // [pulseCountKnob setLinkedKnob:nil];
  
  [super removedFromLayer:_layer_];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionDial.value",@"timeToLiveDial.value",@"pulseEveryDial.value",@"offsetDial.value",nil]];
  return keys;
}

// Tool runner

- (BOOL)shouldPulseOnBeat:(int)_beat_ {
  if( [pulseEveryDial value] < 1 ) {
    return NO;
  } else {
    return ( ( _beat_ - [offsetDial value] ) % [pulseEveryDial value] ) == 0;
  }
}

- (void)start {
  [super start];
  
  [directionDial onStart];
  [timeToLiveDial onStart];
  [pulseEveryDial onStart];
  [offsetDial onStart];
}

- (void)runTool:(ELPlayhead *)_playhead_ {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[directionDial value]
                                                        TTL:[timeToLiveDial value]]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  NSBezierPath *symbolPath;
  symbolPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect( centre.x - radius/3, centre.y - radius/3, 2*radius/3, 2*radius/3 )];
  [symbolPath setLineWidth:2.0];

  [self setToolDrawColor:_attributes_];
  [symbolPath stroke];
  
  [[self hex] drawTriangleInDirection:[directionDial value] withAttributes:_attributes_];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionDial xmlRepresentation]];
  [controlsElement addChild:[timeToLiveDial xmlRepresentation]];
  [controlsElement addChild:[pulseEveryDial xmlRepresentation]];
  [controlsElement addChild:[offsetDial xmlRepresentation]];
  return controlsElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    [self setDirectionDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/knob[@name='direction']" error:_error_] firstXMLElement]
                                                              parent:nil
                                                              player:_player_
                                                               error:_error_]];
    [self setTimeToLiveDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:_error_] firstXMLElement]
                                                               parent:nil
                                                               player:_player_
                                                                error:_error_]];
    [self setPulseEveryDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/knob[@name='pulseEvery']" error:_error_] firstXMLElement]
                                                               parent:nil
                                                               player:_player_
                                                                error:_error_]];
    [self setOffsetDial:[[ELDial alloc] initWithXmlRepresentation:[[_representation_ nodesForXPath:@"controls/knob[@name='offset']" error:_error_] firstXMLElement]
                                                           parent:nil
                                                           player:_player_
                                                            error:_error_]];
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setDirectionDial:[[self directionDial] mutableCopy]];
  [copy setTimeToLiveDial:[[self timeToLiveDial] mutableCopy]];
  [copy setPulseEveryDial:[[self pulseEveryDial] mutableCopy]];
  [copy setOffsetDial:[[self offsetDial] mutableCopy]];
  return copy;
}

@end
