//
//  ELFloatKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedKnob.h"
#import "Elysium.h"

@interface ELFloatKnob : ELRangedKnob <NSMutableCopying> {
  float value;
}

- (id)initWithName:(NSString *)name
        floatValue:(float)value
           minimum:(float)minimum
           maximum:(float)maximum
          stepping:(float)stepping
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)enabled
         linkValue:(BOOL)linkValue
                 p:(float)p
        oscillator:(ELOscillator *)oscillator;

- (id)initWithName:(NSString *)name floatValue:(float)value minimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;
- (id)initWithName:(NSString *)name linkedToFloatKnob:(ELFloatKnob *)knob;

- (float)value;
- (void)setValue:(float)value;

- (float)dynamicValue;
- (float)dynamicValue:(float)value;

@end
