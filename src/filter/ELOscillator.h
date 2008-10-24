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
  BOOL    enabled;
}

@property BOOL enabled;

- (id)initEnabled:(BOOL)enabled;

- (NSString *)type;

- (float)generate;

@end
