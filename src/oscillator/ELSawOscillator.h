//
//  ELSawOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSawOscillator : ELRangedOscillator {
  int rest;
  int attack;
  int sustain;
  int decay;
  
  int attackBase;
  int attackDelta;
  
  int decayBase;
  int decayDelta;
  
  int period;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay;

@property int rest;
@property int attack;
@property int sustain;
@property int decay;

- (float)generateWithT:(int)t;
- (void)updateBasesAndDeltas;

@end
