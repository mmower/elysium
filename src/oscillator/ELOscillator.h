//
//  ELOscillator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

extern NSArray const *ELFilterFunctions;

@interface ELOscillator : NSObject {
  NSString      *function;
  NSString      *name;
  
  ELFloatKnob   *varianceKnob;
  ELFloatKnob   *periodKnob;
  
  NSInvocation  *evalFunction;
}

- (id)initWithName:(NSString *)name function:(NSString *)function variance:(float)variance period:(float)period;
- (id)initWithName:(NSString *)name function:(NSString *)function varianceKnob:(ELFloatKnob *)varianceKnob periodKnob:(ELFloatKnob *)periodKnob;

@property (assign) NSString *name;
@property (assign) NSString *function;

@property (readonly) ELFloatKnob *varianceKnob;
@property (readonly) ELFloatKnob *periodKnob;

- (NSString *)function;

- (float)generate;
- (float)generateWithT:(float)t;

@end
