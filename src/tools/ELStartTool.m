//
//  ELStartTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELStartTool.h"

#import "ELHex.h"
#import "ELConfig.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELStartTool

- (id)initWithDirectionKnob:(ELIntegerKnob *)_directionKnob_ timeToLiveKnob:(ELIntegerKnob *)_timeToLiveKnob_ pulseCountKnob:(ELIntegerKnob *)_pulseCountKnob_ {
  if( ( self = [self initWithType:@"start"] ) ) {
    directionKnob = _directionKnob_;
    timeToLiveKnob = _timeToLiveKnob_;
    pulseCountKnob = _pulseCountKnob_;
  }
  
  return self;
}

- (id)init {
  if( ( self = [super initWithType:@"start"] ) ) {
    directionKnob = [[ELIntegerKnob alloc] initWithName:@"direction" integerValue:N];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive"];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount"];
    
    [self setPreferredOrder:1];
  }
  return self;
}

@synthesize directionKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  
  [timeToLiveKnob setLinkedKnob:[_layer_ timeToLiveKnob]];
  [pulseCountKnob setLinkedKnob:[_layer_ pulseCountKnob]];
  
  [_layer_ addGenerator:self];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [_layer_ removeGenerator:self];
  
  [timeToLiveKnob setLinkedKnob:nil];
  
  [super removedFromLayer:_layer_];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"directionKnob.value",@"timeToLiveKnob.value",nil]];
  return keys;
}

// Tool runner

- (BOOL)shouldPulseOnBeat:(int)_beat_ {
  return ( _beat_ % [pulseCountKnob value] ) == 0;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    NSLog( @"TTL %@ = %d", timeToLiveKnob, [timeToLiveKnob value] );
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[directionKnob value]
                                                        TTL:[timeToLiveKnob value]]];
    return YES;
  } else {
    return NO;
  }
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

// ELData protocol assistance

- (void)saveToolConfig:(NSMutableDictionary *)_attributes_ {
  // [_attributes_ setObject:[config stringForKey:@"direction"] forKey:@"direction"];
  // if( [config definesValueForKey:@"ttl"] ) {
  //   [_attributes_ setObject:[config stringForKey:@"ttl"] forKey:@"ttl"];
  // }
}

- (BOOL)loadToolConfig:(NSXMLElement *)_xml_ {
  NSXMLNode *node;
  
  node = [_xml_ attributeForName:@"direction"];
  if( !node ) {
    return NO;
  }
  
  // [self setDirection:[[node stringValue] intValue]];
  
  node = [_xml_ attributeForName:@"ttl"];
  if( node ) {
    // [self setTimeToLive:[[node stringValue] intValue]];
  }
  
  return YES;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithDirectionKnob:[directionKnob mutableCopy]
                                                     timeToLiveKnob:[timeToLiveKnob mutableCopy]
                                                     pulseCountKnob:[pulseCountKnob mutableCopy]];
}

@end
