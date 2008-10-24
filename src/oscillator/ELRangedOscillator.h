//
//  ELRangedOscillator.h
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELOscillator.h"

@interface ELRangedOscillator : ELOscillator {
  float minimum;
  float maximum;
  
  float range;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum;

@property float minimum;
@property float maximum;
@property (readonly) float range;

@end
