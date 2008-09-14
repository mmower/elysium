//
//  ELFloatKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"

@interface ELFloatKnob : ELKnob {
  float value;
}

- (id)initWithName:(NSString *)name floatValue:(float)value;

- (float)value;
- (void)setValue:(float)value;

@end
