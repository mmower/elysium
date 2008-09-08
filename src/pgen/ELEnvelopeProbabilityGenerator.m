//
//  ELEnvelopeProbabilityGenerator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELEnvelopeProbabilityGenerator.h"

@implementation ELEnvelopeProbabilityGenerator

- (id)initWithPeriod:(float)_period_ {
  if( ( self = [self init] ) ) {
    period = _period_;
  }
  
  return self;
}

@synthesize period;

- (float)generate {
  [self doesNotRecognizeSelector:_cmd];
  return 0.0; // This will not be reached because of the doesNotRecognizeSelector: message
}

@end
