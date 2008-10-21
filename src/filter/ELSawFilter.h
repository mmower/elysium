//
//  ELSawFilter.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedFilter.h"

@interface ELSawFilter : ELRangedFilter {
  float rest;
  float attack;
  float sustain;
  float decay;
  
  float attackBase;
  float attackDelta;
  
  float decayBase;
  float decayDelta;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum rest:(float)rest attack:(float)attack sustain:(float)sustain decay:(float)decay;

@property float rest;
@property float attack;
@property float sustain;
@property float decay;

@end
