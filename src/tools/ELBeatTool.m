//
//  ELBeatTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELBeatTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELConfig.h"
#import "ELPlayhead.h"

@implementation ELBeatTool

- (id)init {
  self = [super initWithType:@"beat"];
  return self;
}

- (NSArray *)observableValues {
  NSMutableArray *keys = [[NSMutableArray alloc] init];
  [keys addObjectsFromArray:[super observableValues]];
  [keys addObjectsFromArray:[NSArray arrayWithObjects:@"velocity",@"duration",nil]];
  return keys;
}

@dynamic velocity;

- (int)velocity {
  return [config integerForKey:@"velocity"];
}

- (void)setVelocity:(int)_velocity {
  [config setInteger:_velocity forKey:@"velocity"];
}

@dynamic duration;

- (float)duration {
  return [config floatForKey:@"duration"];
}

- (void)setDuration:(float)_duration {
  [config setFloat:_duration forKey:@"duration"];
}

// Tool runner

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [layer playNote:[[_playhead position] note]
           velocity:[self velocity]
           duration:[self duration]];
    return YES;
  } else {
    return NO;
  }
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  NSPoint centre = [[self hex] centre];
  float radius = [[self hex] radius];
  
  NSBezierPath *symbolPath = [NSBezierPath bezierPath];
  [symbolPath moveToPoint:NSMakePoint( centre.x - radius / 6, centre.y + radius / 5 )];
  [symbolPath lineToPoint:NSMakePoint( centre.x + radius / 4, centre.y )];
  [symbolPath lineToPoint:NSMakePoint( centre.x - radius / 6, centre.y - radius / 5 )];
  [symbolPath closePath];
  [symbolPath setLineWidth:2.0];
  
  [[_attributes_ objectForKey:ELToolColor] set];
  
  [symbolPath stroke];
}

- (void)saveToolConfig:(NSMutableDictionary *)_attributes_ {
  if( [config definesValueForKey:@"velocity"] ) {
    [_attributes_ setObject:[config stringForKey:@"velocity"] forKey:@"velocity"];
  }
  if( [config definesValueForKey:@"duration"] ) {
    [_attributes_ setObject:[config stringForKey:@"duration"] forKey:@"duration"];
  }
}

- (BOOL)loadToolConfig:(NSXMLElement *)_xml_ {
  NSXMLNode *node;
  
  node = [_xml_ attributeForName:@"velocity"];
  if( node ) {
    [self setVelocity:[[node stringValue] intValue]];
  }
  
  node = [_xml_ attributeForName:@"duration"];
  if( node ) {
    [self setDuration:[[node stringValue] floatValue]];
  }
  
  return YES;
}

@end
