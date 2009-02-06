//
//  ELDial.h
//  Elysium
//
//  Created by Matt Mower on 31/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELXmlData.h"

#import <Cocoa/Cocoa.h>

typedef enum tagELDialMode {
  dialFree,
  dialDynamic,
  dialInherited
} ELDialMode;

@class ELOscillator;

@interface ELDial : NSObject <ELXmlData,NSMutableCopying> {
  id            delegate;
  
  ELDialMode    mode;
  
  NSString      *name;
  NSString      *toolTip;
  int           tag;
  
  ELDial        *parent;
  ELOscillator  *oscillator;
  id            oscillatorController;
  
  int           assigned;
  int           last;
  int           value;
  
  // For range based controls
  int           min;
  int           max;
  int           step;
}

- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value;

- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value
               min:(int)min
               max:(int)max
              step:(int)step;

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
          assigned:(int)aAssigned
               min:(int)aMin
               max:(int)aMax
              step:(int)aStep;

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)tag
         boolValue:(BOOL)value;

- (id)initWithParent:(ELDial *)parent;

@property           id            delegate;
@property           ELDialMode    mode;
@property (assign)  NSString      *name;
@property (assign)  NSString      *toolTip;
@property           int           tag;
@property           ELDial        *parent;
@property           ELOscillator  *oscillator;
@property           id            oscillatorController;
@property           int           assigned;
@property           int           last;
@property           int           value;
@property           int           min;
@property           int           max;
@property           int           step;

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)boolValue;

- (BOOL)isFree;

- (void)onStart;
- (void)onBeat;

@end

@interface NSObject (ELDialDelegation)
- (void)dialDidChangeValue:(ELDial *)dial;
@end
