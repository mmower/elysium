//
//  ELSineOscillator.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELSineOscillator : ELRangedOscillator {
  int period;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum period:(int)period;

@property int period;

- (float)generateWithT:(int)t;

@end
