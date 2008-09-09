//
//  ELEnvelopeProbabilityGenerator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELProbabilityGenerator.h"

@interface ELEnvelopeProbabilityGenerator : ELProbabilityGenerator {
  float variance;
  float period;
}

- (id)initWithBase:(float)base period:(float)period;

@property float variance;
@property float period;

- (float)generate;
- (float)generateWithT:(float)t;

@end
