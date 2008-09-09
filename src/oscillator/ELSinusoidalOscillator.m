//
//  ELSinusoidalOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSinusoidalOscillator.h"

@implementation ELSinusoidalOscillator

- (float)generateWithT:(float)_t_ {
  // Convert to angular form
  float angle = (_t_ / period) * 2 * M_PI * variance;
  
  // Get the sinewave value
  return (1+sin(angle))/2;
}

@end
