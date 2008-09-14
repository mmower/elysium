//
//  ELBooleanKnob.h
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELKnob.h"

@interface ELBooleanKnob : ELKnob {
  BOOL  value;
}

- (id)initWithName:(NSString *)name value:(BOOL)value;

- (BOOL)value;
- (void)setValue:(BOOL)value;

@end
