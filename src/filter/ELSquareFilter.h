//
//  ELSquareFilter.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedFilter.h"

@interface ELSquareFilter : ELRangedFilter {
  float rest;
  float sustain;
}

- (id)initEnabled:(BOOL)enabled minimum:(float)minimum maximum:(float)maximum rest:(float)rest sustain:(float)sustain;

@property float rest;
@property float sustain;

@end
