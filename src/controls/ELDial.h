//
//  ELDial.h
//  Elysium
//
//  Created by Matt Mower on 31/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELXmlData.h"

#import <Cocoa/Cocoa.h>

extern NSString * const dialModeValueTransformer;
extern NSString * const dialHasOscillatorValueTransformer;

typedef enum tagELDialMode {
  dialFree,
  dialDynamic,
  dialInherited
} ELDialMode;

@class ELPlayer;
@class ELOscillator;

@interface ELDial : NSObject <ELXmlData,NSMutableCopying> {
  id            _delegate;
  
  ELDialMode    _mode;
  
  NSString      *_name;
  NSString      *_toolTip;
  int           _tag;
  
  ELPlayer      *_player;
  ELDial        *_parent;
  ELOscillator  *_oscillator;
  
  int           _assigned;
  int           _last;
  int           _value;
  
  // For range based controls
  int           _min;
  int           _max;
  int           _step;
  
  BOOL          _duplicate;
}


- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            player:(ELPlayer *)player
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value;

- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            player:(ELPlayer *)player
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
            player:(ELPlayer *)player
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
@property           ELPlayer      *player;
@property           ELDial        *parent;
@property           ELOscillator  *oscillator;
@property           int           assigned;
@property           int           last;
@property           int           value;
@property           int           min;
@property           int           max;
@property           int           step;
@property           BOOL          duplicate;

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)boolValue;

// Fake properties to make it easier to work with bindings
- (BOOL)isInherited;
- (void)setIsInherited:(BOOL)shouldInherit;

- (void)start;
- (void)stop;

- (BOOL)pTest;

- (ELDial *)duplicateDial;

@end

@interface NSObject (ELDialDelegation)
- (void)dialDidChangeValue:(ELDial *)dial;
@end
