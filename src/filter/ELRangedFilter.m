//
//  ELRangedFilter.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRangedFilter.h"

@implementation ELRangedFilter

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ {
  if( ( self = [super initEnabled:_enabled_] ) ) {
    [self setMinimum:_minimum_];
    [self setMinimum:_maximum_];
  }
  
  return self;
}

@dynamic minimum;

- (float)minimum {
  return minimum;
}

- (void)setMinimum:(float)_minimum_ {
  minimum = _minimum_;
  range = maximum - minimum;
}

@dynamic maximum;

- (float)maximum {
  return maximum;
}

- (void)setMaximum:(float)_maximum_ {
  maximum = _maximum_;
  range = maximum - minimum;
}

@synthesize range;

@end
