//
//  ELOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELOscillator.h"

NSArray const *ELFilterFunctions;

@implementation ELOscillator

+ (void)initialize {
  if( !ELFilterFunctions ) {
    ELFilterFunctions = [[NSArray alloc] initWithObjects:@"Sine",nil];
  }
}

- (id)initWithName:(NSString *)_name_ function:(NSString *)_function_ variance:(float)_variance_ period:(float)_period_ {
  return [self initWithName:_name_
                   function:_function_
               varianceKnob:[[ELFloatKnob alloc] initWithName:@"variance" floatValue:_variance_]
                 periodKnob:[[ELFloatKnob alloc] initWithName:@"period" floatValue:_period_]];
}

- (id)initWithName:(NSString *)_name_ function:(NSString *)_function_ varianceKnob:(ELFloatKnob *)_varianceKnob_ periodKnob:(ELFloatKnob *)_periodKnob_ {
  if( ( self = [self init] ) ) {
    name         = _name_;
    function     = _function_;
    varianceKnob = _varianceKnob_;
    periodKnob   = _periodKnob_;
  }
  
  return self;
}

@synthesize name;
@synthesize function;
@synthesize varianceKnob;
@synthesize periodKnob;

- (NSString *)description {
  return name;
}

- (float)generate {
  // Get time in tenths of a second
  UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000000;
  
  // Find out where we are in the cycle
  time = time % (int)( [periodKnob filteredValue] * 10 );
  
  float t = time / 10.0;
  
  return [self generateWithT:t];
}

- (float)generateWithT:(float)_t_ {
  if( !evalFunction ) {
    
    SEL sel = NSSelectorFromString( [NSString stringWithFormat:@"generate%@WithT:", function] );
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:sel];
    
    evalFunction = [NSInvocation invocationWithMethodSignature:sig];
    [evalFunction setTarget:self];
    [evalFunction setSelector:sel];

    NSAssert1( evalFunction, @"Unable to obtain SEL for filter function! (%@)", function );
  }
  
  [evalFunction setArgument:&_t_ atIndex:2];
  [evalFunction invoke];
  
  float result;
  [evalFunction getReturnValue:&result];
  return result;
}

- (float)generateSineWithT:(float)_t_ {
  // Convert to angular form
  float angle = (_t_ / [periodKnob filteredValue]) * 2 * M_PI * [varianceKnob filteredValue];
  
  // Get the sinewave value
  return (1+sin(angle))/2;
}

@end
