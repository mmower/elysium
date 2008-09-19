//
//  ELIntegerKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"
#import "Elysium.h"

@interface ELIntegerKnob : ELKnob <NSMutableCopying> {
  int value;
}

- (id)initWithName:(NSString *)name
      integerValue:(int)value
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
            filter:(ELOscillator *)filter
        linkFilter:(BOOL)linkFilter
         predicate:(NSPredicate *)predicate
     linkPredicate:(BOOL)linkPredicate;

- (id)initWithName:(NSString *)name integerValue:(int)value;
- (id)initWithName:(NSString *)name linkedTo:(ELKnob *)knob;

- (int)value;
- (int)filteredValue:(int)value;
- (void)setValue:(int)value;

@end
