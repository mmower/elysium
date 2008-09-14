//
//  ELOscillator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELOscillator : NSObject {
  NSString  *name;
  float     variance;
  float     period;
}

- (id)initWithName:(NSString *)name base:(float)base period:(float)period;

@property (assign) NSString *name;
@property float base;
@property (readonly) float variance;
@property float period;

- (NSString *)type;

- (float)variance;
- (float)generate;
- (float)generateWithT:(float)t;

@end
