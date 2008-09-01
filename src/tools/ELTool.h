//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELData.h"

@class ELHex;
@class ELLayer;
@class ELConfig;
@class ELPlayhead;

@protocol DirectedTool
- (BOOL)direction;
- (void)setDirection:(Direction)direction;
@end

@interface ELTool : NSObject <ELData> {
  BOOL      enabled;
  NSString  *toolType;
  ELLayer   *layer;
  ELHex     *hex;
  ELConfig  *config;
  int       preferredOrder;
}

@property BOOL enabled;
@property int preferredOrder;
@property (readonly) NSString *toolType;
@property (readonly) ELConfig *config;
@property (readonly) ELLayer *layer;
@property (readonly) ELHex *hex;

+ (ELTool *)fromXMLData:(NSXMLElement *)xml;

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type config:(ELConfig *)config;

- (void)useInheritedConfig:(NSString *)key;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (BOOL)run:(ELPlayhead *)playhead;

// Cooperate with ELData protocol

- (void)saveToolConfig:(NSMutableDictionary *)attributes;
- (BOOL)loadToolConfig:(NSXMLElement *)xml;

// Drawing

- (void)drawWithAttributes:(NSDictionary *)attributes;

@end
