//
//  ELOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELOscillator.h"

@implementation ELOscillator

- (id)initWithBase:(float)_base_ period:(float)_period_ {
  if( ( self = [self init] ) ) {
    variance = 1 - _base_;
    period   = _period_;
  }
  
  return self;
}

@synthesize variance;
@synthesize period;

- (float)generate {
  // Get time in tenths of a second
  UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000000;
  
  // Find out where we are in the cycle
  time = time % (int)( [self period] * 10 );
  
  float t = time / 10.0;
  
  return [self generateWithT:t];
}

- (float)generateWithT:(float)_t_ {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // This will not be reached because of the doesNotRecognizeSelector: message
}

@end
