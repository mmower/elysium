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

+ (id)new {
  return [[ELBeatTool alloc] init];
}

- (id)init {
  self = [super initWithType:@"beat"];
  return self;
}

- (id)initWithVelocity:(int)_velocity duration:(float)_duration {
  if( self = [super initWithType:@"beat"] ) {
    [self setVelocity:_velocity];
    [self setDuration:_duration];
  }
  
  return self;
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

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [layer playNote:[[_playhead position] note]
         velocity:[self velocity]
         duration:[self duration]];
}

// Drawing

- (void)drawWithAttributes:(NSDictionary *)_attributes_ {
  [[self hex] drawText:[[[self hex] note] name]];
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
