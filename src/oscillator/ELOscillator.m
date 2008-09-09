//
//  ELOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELOscillator.h"

@implementation ELOscillator

- (id)initWithName:(NSString *)_name_ base:(float)_base_ period:(float)_period_ {
  if( ( self = [self init] ) ) {
    name     = _name_;
    variance = 1 - _base_;
    period   = _period_;
  }
  
  return self;
}

@synthesize name;
@synthesize period;
@synthesize variance;

@dynamic base;

- (float)base {
  return 1 - variance;
}

- (void)setBase:(float)_base_ {
  variance = 1.0 - _base_;
}

- (NSString *)type {
  [self doesNotRecognizeSelector:_cmd];
  return @""; // This will not be reached because of the doesNotRecognizeSelector: message
}

- (float)generate {
  // Get time in tenths of a second
  UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000000;
  
  // Find out where we are in the cycle
  time = time % (int)( period * 10 );
  
  float t = time / 10.0;
  
  return [self generateWithT:t];
}

- (float)generateWithT:(float)_t_ {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // This will not be reached because of the doesNotRecognizeSelector: message
}

@end
