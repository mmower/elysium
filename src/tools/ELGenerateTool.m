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
  }
  
  return self;
}

- (id)init {
  return [self initWithDirectionKnob:[[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N minimum:0 maximum:5 stepping:1]
                      timeToLiveKnob:[[ELIntegerKnob alloc] initWithName:@"timeToLive"]
                      pulseCountKnob:[[ELIntegerKnob alloc] initWithName:@"pulseCount"]
                          offsetKnob:[[ELIntegerKnob alloc] initWithName:@"offset" integerValue:0 minimum:0 maximum:64 stepping:1]];
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
  int pulseCount = [pulseCountKnob dynamicValue];
  if( pulseCount < 1 ) {
    return NO;
  } else {
    return ( ( _beat_ - [offsetKnob dynamicValue] ) % pulseCount ) == 0;
  }
}

- (void)start {
  [super start];
  
  [directionKnob start];
  [timeToLiveKnob start];
  [pulseCountKnob start];
  [offsetKnob start];
}

- (void)runTool:(ELPlayhead *)_playhead_ {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[directionKnob value]
                                                        TTL:[timeToLiveKnob dynamicValue]]];
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
  
  [[self hex] drawTriangleInDirection:[directionKnob value] withAttributes:_attributes_];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)controlsXmlRepresentation {
  NSXMLElement *controlsElement = [super controlsXmlRepresentation];
  [controlsElement addChild:[directionKnob xmlRepresentation]];
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[offsetKnob xmlRepresentation]];
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
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] timeToLiveKnob] player:_player_ error:_error_];
      } else {
        timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive"];
      }
      [timeToLiveKnob setMinimum:1 maximum:999 stepping:1];
      
      if( timeToLiveKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[[_parent_ layer] pulseCountKnob] player:_player_ error:_error_];
      } else {
        pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount"];
      }
      [pulseCountKnob setMinimum:1 maximum:999 stepping:1];
      
      if( pulseCountKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
    
    if( ( nodes = [_representation_ nodesForXPath:@"controls/knob[@name='offset']" error:_error_] ) ) {
      if( ( element = [nodes firstXMLElement] ) ) {
        offsetKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        offsetKnob = [[ELIntegerKnob alloc] initWithName:@"offset" integerValue:0 minimum:0 maximum:64 stepping:1];
      }
      [offsetKnob setMinimum:0 maximum:64 stepping:1];
      
      if( offsetKnob == nil ) {
        return nil;
      }
    } else {
      return nil;
    }
  }
  
  return self;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  id copy = [super mutableCopyWithZone:_zone_];
  [copy setDirectionKnob:[[self directionKnob] mutableCopy]];
  [copy setTimeToLiveKnob:[[self timeToLiveKnob] mutableCopy]];
  [copy setPulseCountKnob:[[self pulseCountKnob] mutableCopy]];
  [copy setOffsetKnob:[[self offsetKnob] mutableCopy]];
  return copy;
}

@end
