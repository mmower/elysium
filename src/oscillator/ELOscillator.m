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
    ELFilterFunctions = [[NSArray alloc] initWithObjects:@"sine",nil];
  }
}

- (id)initWithName:(NSString *)_name_ variance:(float)_variance_ period:(float)_period_ {
  return [self initWithName:_name_
                varianceKnob:[[ELFloatKnob alloc] initWithName:@"variance" floatValue:_variance_]
                  periodKnob:[[ELFloatKnob alloc] initWithName:@"period" floatValue:_period_]];
}

- (id)initWithName:(NSString *)_name_ varianceKnob:(ELFloatKnob *)_varianceKnob_ periodKnob:(ELFloatKnob *)_periodKnob_ {
  if( ( self = [self init] ) ) {
    name         = _name_;
    varianceKnob = _varianceKnob_;
    periodKnob   = _periodKnob_;
  }
  
  return self;
}

@synthesize name;
@synthesize varianceKnob;
@synthesize periodKnob;

- (NSString *)function {
  [self doesNotRecognizeSelector:_cmd];
  return @""; // This will not be reached because of the doesNotRecognizeSelector: message
}

- (NSString *)description {
  return name;
}

- (float)generate {
  // Get time in tenths of a second
  UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000000;
  
  // Find out where we are in the cycle
  time = time % (int)( [periodKnob value] * 10 );
  
  float t = time / 10.0;
  
  return [self generateWithT:t];
}

- (float)generateWithT:(float)_t_ {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // This will not be reached because of the doesNotRecognizeSelector: message but the compiler doesn't know that.
}

@end
