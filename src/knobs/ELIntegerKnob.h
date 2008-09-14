//
//  ELIntegerKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"

@interface ELIntegerKnob : ELKnob {
  int value;
}

- (id)initWithName:(NSString *)name integerValue:(int)value;

- (int)value;
- (void)setValue:(int)value;

@end
