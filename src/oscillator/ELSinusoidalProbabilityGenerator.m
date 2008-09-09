//
//  ELSinusoidalProbabilityGenerator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELSinusoidalProbabilityGenerator.h"

@implementation ELSinusoidalProbabilityGenerator



- (float)generateWithT:(float)_t_ {
  // Convert to angular form
  float angle = (_t_ / period) * 2 * M_PI * variance;
  
  // Get the sinewave value
  return (1+sin(angle))/2;
}


@end
