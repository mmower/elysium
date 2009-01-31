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
  dialDisabled,
  dialFree,
  dialDynamic,
  dialInherited
} ELDialMode;

@interface ELDial : NSObject <ELXmlData,NSMutableCopying> {
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

@property ELDialMode    mode;
@property NSString      *name;
@property int           tag;
@property ELDial        *parent;
@property ELOscillator  *oscillator;
@property int           assigned;
@property int           last;
@property int           value;
@property int           min;
@property int           max;
@property int           step;

@end
