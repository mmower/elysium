//
//  ELOscillator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@interface ELOscillator : NSObject <ELXmlData> {
  BOOL    enabled;
}

+ (ELOscillator *)loadFromXml:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error;

@property BOOL enabled;

- (id)initEnabled:(BOOL)enabled;

- (NSString *)type;

- (float)generate;

- (void)storeAttributes:(NSMutableDictionary *)attributes;

@end
