//
//  ELFilter.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@interface ELFilter : NSObject <ELXmlData> {
  float         minimum;
  float         maximum;
  float         range;
}

- (id)initWithMinimum:(float)minimum maximum:(float)maximum;

@property float minimum;
@property float maximum;
@property (readonly) float range;

- (NSString *)type;
- (int)periodInMillis;

- (float)generate;
- (float)generateWithT:(int)t;

@end
