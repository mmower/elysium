//
//  ELRampOscillator.h
//  Elysium
//
//  Created by Matt Mower on 07/03/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedOscillator.h"

@interface ELRampOscillator : ELRangedOscillator {
  int   period;
  BOOL  rising;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum period:(int)period rising:(BOOL)rising;

@property int   period;
@property BOOL  rising;

- (int)generateWithT:(int)t;

@end
