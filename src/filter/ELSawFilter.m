//
//  ELSawFilter.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSawFilter.h"

#import "ELFilter.h"

@implementation ELSawFilter

- (id)initWithName:(NSString *)_name_ minimum:(float)_minimum_ maximum:(float)_maximum_ rest:(float)_rest_ attack:(float)_attack_ sustain:(float)_sustain_ decay:(float)_decay_ {
  if( ( self = [super initWithMinimum:_minimum_ maximum:_maximum_] ) ) {
    [self setRest:_rest_];
    [self setAttack:_attack_];
    [self setSustain:_sustain_];
    [self setDecay:_decay_];
  }
  
  return self;
}

- (NSString *)type {
  return @"saw";
}

@synthesize rest;
@synthesize attack;
@synthesize sustain;
@synthesize decay;

- (int)periodInMillis {
  return rest + attack + sustain + decay;
}

- (float)generateWithT:(int)_t_ {
  if( _t_ <= rest ) {
    return minimum;
  } else if( _t_ <= attack ) {
    return ( attackDelta * ( _t_ - attackBase ) ) + minimum;
  } else if( _t_ <= sustain ) {
    return maximum;
  } else {
    return ( decayDelta * ( _t_ - decayBase ) ) + minimum;
  }
}

@end
