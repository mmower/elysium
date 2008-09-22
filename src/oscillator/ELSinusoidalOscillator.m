//
//  ELSinusoidalOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSinusoidalOscillator.h"

@implementation ELSinusoidalOscillator

- (NSString *)type {
  return @"Sine";
}

- (float)generateWithT:(float)_t_ {
  // Convert to angular form
  float angle = (_t_ / [periodKnob value]) * 2 * M_PI * [varianceKnob value];
  
  // Get the sinewave value
  return (1+sin(angle))/2;
}

@end
