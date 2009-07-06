//
//  ELSquareOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSquareOscillator : ELRangedOscillator {
  int _rest;
  int _sustain;
  
  int _period;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)rest sustain:(int)sustain;

@property int rest;
@property int sustain;

- (void)updatePeriod;
- (int)generateWithT:(int)t;

@end
