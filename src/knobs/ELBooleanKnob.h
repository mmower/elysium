//
//  ELBooleanKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"
#import "Elysium.h"

@interface ELBooleanKnob : ELKnob <NSMutableCopying> {
  BOOL  value;
}

- (id)initWithName:(NSString*)name
      booleanValue:(BOOL)value
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)_enabled
         linkValue:(BOOL)_linkValue
        oscillator:(ELOscillator *)oscillator;
         
- (id)initWithName:(NSString *)name booleanValue:(BOOL)value;
- (id)initWithName:(NSString *)name linkedToBooleanKnob:(ELBooleanKnob *)knob;

- (BOOL)value;
- (void)setValue:(BOOL)value;

@end
