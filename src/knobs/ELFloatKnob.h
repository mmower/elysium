//
//  ELFloatKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"
#import "Elysium.h"

@interface ELFloatKnob : ELKnob <NSMutableCopying> {
  float value;
}

- (id)initWithName:(NSString *)name
        floatValue:(float)value
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)_enabled
        hasEnabled:(BOOL)_hasEnabled
       linkEnabled:(BOOL)_linkEnabled
          hasValue:(BOOL)_hasValue
         linkValue:(BOOL)_linkValue
             alpha:(float)_alpha
          hasAlpha:(BOOL)_hasAlpha
         linkAlpha:(BOOL)_linkAlpha
                 p:(float)_p
              hasP:(BOOL)_hasP
             linkP:(BOOL)_linkP
            filter:(ELFilter *)filter
        linkFilter:(BOOL)linkFilter
         predicate:(NSPredicate *)predicate
     linkPredicate:(BOOL)linkPredicate;

- (id)initWithName:(NSString *)name floatValue:(float)value;
- (id)initWithName:(NSString *)name linkedTo:(ELKnob *)knob;

- (float)value;
- (float)filteredValue;
- (float)filteredValue:(float)value;
- (void)setValue:(float)value;

@end
