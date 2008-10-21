//
//  ELSineFilter.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELRangedFilter.h"

@interface ELSineFilter : ELRangedFilter {
  float period;
}

@property float period;

@end
