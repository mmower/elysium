//
//  ELSawOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSawOscillator : ELRangedOscillator {
  int _rest;
  int _attack;
  int _sustain;
  int _decay;
  
  int _attackBase;
  float _attackDelta;
  
  int _decayBase;
  float _decayDelta;
  
  int _period;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay;
- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay;

@property int rest;
@property int attack;
@property int sustain;
@property int decay;

- (int)generateWithT:(int)t;
- (void)updateBasesAndDeltas;

@end
