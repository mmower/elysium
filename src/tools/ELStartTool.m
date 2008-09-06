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

- (id)init {
  if( self = [super initWithType:@"start"] ) {
    [self setDirection:N];
    [self setPreferredOrder:1];
  }
  return self;
}

- (void)addedToLayer:(ELLayer *)_layer_ atPosition:(ELHex *)_hex_ {
  [super addedToLayer:_layer_ atPosition:_hex_];
  [_layer_ addGenerator:self];
}

- (void)removedFromLayer:(ELLayer *)_layer_ {
  [_layer_ removeGenerator:self];
  [super removedFromLayer:_layer_];
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"direction",@"timeToLive",nil]];
  return keys;
}

@dynamic direction;

- (Direction)direction {
  return [config integerForKey:@"direction"];
}

- (void)setDirection:(Direction)_direction_ {
  [config setInteger:_direction_ forKey:@"direction"];
}

@dynamic timeToLive;

- (int)timeToLive {
  return [config integerForKey:@"ttl"];
}

- (void)setTimeToLive:(int)_ttl_ {
  [config setInteger:_ttl_ forKey:@"ttl"];
}

@dynamic pulseCount;

- (int)pulseCount {
  return [config integerForKey:@"pulseCount"];
}

- (void)setPulseCount:(int)_pulseCount_ {
  [config setInteger:_pulseCount_ forKey:@"pulseCount"];
}

// Tool runner

- (BOOL)shouldPulseOnBeat:(int)_beat_ {
  return ( _beat_ % [self pulseCount] ) == 0;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[self direction]
                                                        TTL:[self timeToLive]]];
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

  [[_attributes_ objectForKey:ELToolColor] set];
  [symbolPath stroke];
  
  [[self hex] drawTriangleInDirection:[self direction] withAttributes:_attributes_];
}

// ELData protocol assistance

- (void)saveToolConfig:(NSMutableDictionary *)_attributes_ {
  [_attributes_ setObject:[config stringForKey:@"direction"] forKey:@"direction"];
  if( [config definesValueForKey:@"ttl"] ) {
    [_attributes_ setObject:[config stringForKey:@"ttl"] forKey:@"ttl"];
  }
}

- (BOOL)loadToolConfig:(NSXMLElement *)_xml_ {
  NSXMLNode *node;
  
  node = [_xml_ attributeForName:@"direction"];
  if( !node ) {
    return NO;
  }
  
  [self setDirection:[[node stringValue] intValue]];
  
  node = [_xml_ attributeForName:@"ttl"];
  if( node ) {
    [self setTimeToLive:[[node stringValue] intValue]];
  }
  
  return YES;
}

@end
