//
//  ELSquareOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSquareOscillator : ELRangedOscillator {
  int rest;
  int sustain;
  
  int period;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum rest:(int)rest sustain:(int)sustain;

@property int rest;
@property int sustain;

- (void)updatePeriod;
- (float)generateWithT:(int)t;

@end
