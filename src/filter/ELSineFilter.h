//
//  ELSineFilter.h
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELFilter.h"

@interface ELSineFilter : ELFilter {
  float period;
}

@property float period;

@end
