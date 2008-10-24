//
//  ELRangedFilter.h
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELFilter.h"

@interface ELRangedFilter : ELFilter {
  float minimum;
  float maximum;
  
  float range;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum;

@property float minimum;
@property float maximum;
@property (readonly) float range;

@end
