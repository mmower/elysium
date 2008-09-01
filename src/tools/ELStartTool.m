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

@dynamic direction;

- (Direction)direction {
  return [config integerForKey:@"direction"];
}

- (void)setDirection:(Direction)_direction_ {
  [config setInteger:_direction_ forKey:@"direction"];
}

@dynamic TTL;

- (int)TTL {
  return [config integerForKey:@"ttl"];
}

- (void)setTTL:(int)_ttl {
  [config setInteger:_ttl forKey:@"ttl"];
}

// Tool runner

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                  direction:[self direction]
                                                        TTL:[self TTL]]];
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
  symbolPath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect( centre.x - radius/4, centre.y - radius/4, radius/2, radius/2 )];
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
    [self setTTL:[[node stringValue] intValue]];
  }
  
  return YES;
}

@end
