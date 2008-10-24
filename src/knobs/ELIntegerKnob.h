//
//  ELIntegerKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
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
        hasEnabled:(BOOL)_hasEnabled
       linkEnabled:(BOOL)_linkEnabled
          hasValue:(BOOL)_hasValue
         linkValue:(BOOL)_linkValue
            filter:(ELOscillator *)filter
        linkFilter:(BOOL)linkFilter;

- (id)initWithName:(NSString *)name integerValue:(int)value minimum:(float)minimum maximum:(float)maximum stepping:(float)stepping;
- (id)initWithName:(NSString *)name linkedToIntegerKnob:(ELIntegerKnob *)knob;

- (int)value;
- (int)filteredValue;
- (int)filteredValue:(int)value;
- (void)setValue:(int)value;

@end
