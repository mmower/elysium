//
//  ELKnob.h
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELData.h"

@class ELOscillator;

typedef enum {
  BOOLEAN_KNOB,
  INTEGER_KNOB,
  FLOAT_KNOB,
  } KnobType;

@interface ELKnob : NSObject <ELData> {
  NSString        *name;            // name assigned to the knob
  KnobType        type;             // the type of the value controller by this knob
  
  ELKnob          *linkedKnob;      // a "parent" knob that may
  
  NSNumber        *enabled;         // whether this knob is enabled or not
  BOOL            linkEnabled;
  
  BOOL            hasValue;         // If a value is stored in this knob
  BOOL            linkValue;
  
  BOOL            boolValue;        // If boolean
  int             intValue;         // If integer
  float           floatValue;       // If float
  
  NSNumber        *alpha;           // alpha is the current squashing factor
  BOOL            linkAlpha;
  
  NSNumber        *p;               // p is the probability this knob is enabled
  BOOL            linkP;
  
  ELOscillator    *filter;          // an oscillator that can be linked to alpha
  BOOL            linkFilter;
  
  NSPredicate     *predicate;       // a predicate that be used to govern whether
  BOOL            linkPredicate;    // this knob is enabled or not
}

- (id)initWithType:(KnobType)type name:(NSString *)name;

- (NSString *)name;
- (KnobType)type;

- (ELKnob *)linkedKnob;
- (void)setLinkedKnob:(ELKnob *)linkedKnob;

- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;

- (BOOL)linkEnabled;
- (void)setLinkEnabled:(BOOL)linkEnabled;

- (BOOL)linkValue;
- (void)setLinkValue:(BOOL)linkValue;

- (int)intValue;
- (void)setIntValue:(int)value;

- (float)floatValue;
- (void)setFloatValue:(float)value;

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)value;

- (float)alpha;
- (void)setAlpha:(float)alpha;

- (BOOL)linkAlpha;
- (void)setLinkAlpha:(BOOL)linkAlpha;

- (float)p;
- (void)setP:(float)p;

- (BOOL)linkP;
- (void)setLinkP:(BOOL)linkP;

- (ELOscillator *)filter;
- (void)setFilter:(ELOscillator *)filter;

- (BOOL)linkFilter;
- (void)setLinkFilter:(BOOL)linkFilter;

- (NSPredicate *)predicate;
- (void)setPredicate:(NSPredicate *)predicate;

- (BOOL)linkPredicate;
- (void)setLinkPredicate:(BOOL)linkPredicate;

@end
