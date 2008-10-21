//
//  ELSquareFilter.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSquareFilter.h"

#import "ELFilter.h"

@implementation ELSquareFilter

- (id)initWithMinimum:(float)_minimum_ maximum:(float)_maximum_ rest:(float)_rest_ sustain:(float)_sustain_ {
  if( ( self = [super initWithMinimum:_minimum_ maximum:_maximum_] ) ) {
    [self setRest:_rest_];
    [self setSustain:_sustain_];
  }
  
  return self;
}

- (NSString *)type {
  return @"Square";
}

@synthesize rest;
@synthesize sustain;

- (float)generateWithT:(int)_t_ {
  if( _t_ < sustain ) {
    return minimum;
  } else {
    return maximum;
  }
}

@end
