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

@end
