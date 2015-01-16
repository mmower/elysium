//
//  ELOscillator.h
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@interface ELOscillator : NSObject <ELXmlData> {
  BOOL      _enabled;
  UInt64    _timeBase;
  
  int       _value;
}

+ (ELOscillator *)loadFromXml:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error;

@property  (nonatomic) BOOL    enabled;
@property UInt64  timeBase;
@property  (nonatomic) int     value;

- (id)initEnabled:(BOOL)enabled;

- (NSString *)type;

- (void)start;
- (void)stop;
- (void)update;
- (int)generate;

- (void)storeAttributes:(NSMutableDictionary *)attributes;

- (void)resetTimeBase;

@end
