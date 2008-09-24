//
//  ELFilter.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

extern NSArray const *ELFilterFunctions;

@interface ELFilter : NSObject <ELXmlData> {
  NSString      *function;
  NSString      *name;
  
  float         variance;
  float         period;
  
  NSInvocation  *evalFunction;
}

- (id)initWithName:(NSString *)name function:(NSString *)function variance:(float)variance period:(float)period;

@property (assign) NSString *name;
@property (assign) NSString *function;
@property float variance;
@property float period;

- (float)generate;
- (float)generateWithT:(float)t;

@end
