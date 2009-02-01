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
  int           tag;
  
  ELDial        *parent;
  ELOscillator  *oscillator;
  
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
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value;

- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value
               min:(int)min
               max:(int)max
              step:(int)step;

- (id)initWithParent:(ELDial *)parent;

@property           id            delegate;
@property           ELDialMode    mode;
@property (assign)  NSString      *name;
@property           int           tag;
@property           ELDial        *parent;
@property           ELOscillator  *oscillator;
@property           int           assigned;
@property           int           last;
@property           int           value;
@property           int           min;
@property           int           max;
@property           int           step;

- (BOOL)boolValue;
- (void)setBoolValue:(BOOL)boolValue;

@end
