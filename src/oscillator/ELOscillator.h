//
//  ELOscillator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@interface ELOscillator : NSObject {
  NSString    *name;
  
  ELFloatKnob *varianceKnob;
  ELFloatKnob *periodKnob;
}

- (id)initWithName:(NSString *)name variance:(float)variance period:(float)period;
- (id)initWithName:(NSString *)name varianceKnob:(ELFloatKnob *)varianceKnob periodKnob:(ELFloatKnob *)periodKnob;

@property (assign) NSString *name;

@property (readonly) ELFloatKnob *varianceKnob;
@property (readonly) ELFloatKnob *periodKnob;

- (NSString *)type;

- (float)generate;
- (float)generateWithT:(float)t;

@end
