//
//  ELSineFilter.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSineFilter.h"

@implementation ELSineFilter

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ period:(float)_period_ {
  if( ( self = [super initEnabled:_enabled_ minimum:_minimum_ maximum:_maximum_] ) ) {
    period = _period_;
  }
  
  return self;
}

- (NSString *)type {
  return @"Sine";
}

@synthesize period;

- (float)generateWithT:(int)_t_ {
  // Convert to angular form and use as a proportion of the range
  return minimum + ( range * sin( ( _t_ / period ) * M_PI ) );
}

@end
