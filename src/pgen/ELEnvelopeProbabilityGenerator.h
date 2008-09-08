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
  float period;
}

@property float period;

- (float)generate;

@end
