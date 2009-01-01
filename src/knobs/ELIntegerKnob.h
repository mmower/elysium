//
//  ELIntegerKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedKnob.h"
#import "Elysium.h"

@interface ELIntegerKnob : ELRangedKnob <NSMutableCopying> {
  int value;
}

- (id)initWithName:(NSString *)name
      integerValue:(int)value
           minimum:(float)minimum
           maximum:(float)maximum
          stepping:(float)stepping
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)_enabled
         linkValue:(BOOL)_linkValue
        oscillator:(ELOscillator *)oscillator;

- (id)initWithName:(NSString *)name integerValue:(int)value minimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;
- (id)initWithName:(NSString *)name linkedToIntegerKnob:(ELIntegerKnob *)knob;

- (int)value;
- (int)dynamicValue;
- (int)dynamicValue:(int)value;
- (void)setValue:(int)value;

@end
