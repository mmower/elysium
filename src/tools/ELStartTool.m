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
  self = [super initWithType:@"start"];
  return self;
}

- (id)initWithDirection:(Direction)_direction TTL:(int)_ttl {
  if( self = [super initWithType:@"start"] ) {
    [self setDirection:_direction];
    [self setTTL:_ttl];
  }

  return self;
}

@dynamic direction;

- (Direction)direction {
  return [config integerForKey:@"direction"];
}

- (void)setDirection:(Direction)_direction {
  [config setInteger:_direction forKey:@"direction"];
}

@dynamic TTL;

- (int)TTL {
  return [config integerForKey:@"ttl"];
}

- (void)setTTL:(int)_ttl {
  [config setInteger:_ttl forKey:@"ttl"];
}

// Tool runner

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                direction:[self direction]
                                                      TTL:[self TTL]]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSRect bounds = [[[self hex] path] bounds];
  CGFloat width = NSWidth( bounds );
  CGFloat height = NSHeight( bounds );
  
  Direction d = ( 6 - [self direction] ) % 6;
  d = ( 6 - d ) % 6;
  // NSLog( @"Direction = %d", d );
  
  NSAffineTransform *transform = [NSAffineTransform transform];
  [transform translateXBy:[[self hex] centre].x yBy:[[self hex] centre].y];
  [transform rotateByDegrees:d * 60];
  [transform translateXBy:-[[self hex] centre].x yBy:-[[self hex]centre].y];
  
  NSRect drawingBox = NSMakeRect( [[self hex] centre].x - width/16, [[self hex] centre].y - height / 4, width/8, width/8 );
  NSBezierPath *symbolPath = [NSBezierPath bezierPathWithOvalInRect:drawingBox];
  [symbolPath transformUsingAffineTransform:transform];
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
