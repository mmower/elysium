//
//  ELKnob.h
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELXmlData.h"

@class ELOscillator;

@interface ELKnob : NSObject <ELXmlData> {
  NSString        *name;            // name assigned to the knob
  
  ELKnob          *linkedKnob;      // a "parent" knob that may
  
  BOOL            enabled;          // whether this knob is enabled or not
  BOOL            hasEnabled;
  BOOL            linkEnabled;
  
  BOOL            hasValue;         // If a value is stored in this knob
  BOOL            linkValue;
  
  ELOscillator    *oscillator;          // an function that supplies a dynamic alpha value in real-time
  id              oscillatorController;
}

@property id oscillatorController;

- (id)initWithName:(NSString *)name
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)enabled
        hasEnabled:(BOOL)hasEnabled
       linkEnabled:(BOOL)linkEnabled
          hasValue:(BOOL)hasValue
         linkValue:(BOOL)linkValue
        oscillator:(ELOscillator *)oscillator;
       
- (id)initWithName:(NSString *)name;

- (NSString *)name;

- (NSString *)xmlType;

- (BOOL)encodesType:(char *)type;

- (NSString *)stringValue;
- (void)setValueWithString:(NSString *)stringValue;

- (void)clearValue;

- (ELKnob *)linkedKnob;
- (void)setLinkedKnob:(ELKnob *)linkedKnob;

- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;

- (BOOL)linkEnabled;
- (void)setLinkEnabled:(BOOL)linkEnabled;

- (BOOL)linkValue;
- (void)setLinkValue:(BOOL)linkValue;

- (ELOscillator *)oscillator;
- (void)setOscillator:(ELOscillator *)oscillator;

@end
