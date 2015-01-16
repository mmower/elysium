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
    
    float _attackDelta;
    float _decayDelta;
    
    int _period;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay;
- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay;

@property (nonatomic) int rest;
@property (nonatomic) int attack;
@property (nonatomic) int sustain;
@property (nonatomic) int decay;

- (int)generateWithT:(int)t;
- (void)updateBasesAndDeltas;

@end
