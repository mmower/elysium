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
  int   _period;
  BOOL  _rising;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum period:(int)period rising:(BOOL)rising;
- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum period:(int)period rising:(BOOL)rising;

@property  (nonatomic) int   period;
@property  (nonatomic) BOOL  rising;

- (int)generateWithT:(int)t;

@end
