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
  int             tag;              // an object that is associated with this knob
  
  ELKnob          *linkedKnob;      // a "parent" knob that may
  
  BOOL            enabled;          // whether this knob is enabled or not
  
  BOOL            linkValue;
  
  ELOscillator    *oscillator;          // an function that supplies a dynamic alpha value in real-time
  id              oscillatorController;
}

- (id)initWithName:(NSString *)name
        linkedKnob:(ELKnob *)knob
           enabled:(BOOL)enabled
         linkValue:(BOOL)linkValue
        oscillator:(ELOscillator *)oscillator;

- (id)initWithName:(NSString *)name;

@property BOOL enabled;
@property (readonly) NSString *name;
@property int tag;
@property (readonly) NSString *xmlType;
@property (readonly) NSString *typeName;
@property (readonly) NSString *stringValue;
@property (assign) ELKnob *linkedKnob;
@property BOOL linkValue;
@property (assign) ELOscillator *oscillator;
@property id oscillatorController;

- (void)start;

- (BOOL)encodesType:(char *)type;
- (void)setValueWithString:(NSString *)stringValue;

@end
