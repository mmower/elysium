//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELHex;
@class ELLayer;
@class ELPlayhead;

@protocol DirectedTool
@property (readonly) ELIntegerKnob *directionKnob;
@end

@interface ELTool : NSObject <ELXmlData> {
  BOOL      enabled;
  NSString  *toolType;
  ELLayer   *layer;
  ELHex     *hex;
  int       preferredOrder;
}

@property BOOL enabled;
@property int preferredOrder;
@property (readonly) NSString *toolType;
@property (readonly) ELLayer *layer;
@property (readonly) ELHex *hex;

+ (NSDictionary *)toolMapping;
+ (void)addToolMapping:(Class)class forKey:(NSString *)key;
+ (id)toolAlloc:(NSString *)key;

- (id)initWithType:(NSString *)type;

- (NSArray *)observableValues;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (BOOL)run:(ELPlayhead *)playhead;

- (void)drawWithAttributes:(NSDictionary *)attributes;

@end
