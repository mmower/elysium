//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELData.h"

@class ELHex;
@class ELLayer;
@class ELConfig;
@class ELPlayhead;

@interface ELTool : NSObject <ELData> {
  BOOL      enabled;
  NSString  *toolType;
  ELLayer   *layer;
  ELHex     *hex;
  ELConfig  *config;
}

@property BOOL enabled;
@property (readonly) NSString *toolType;
@property (readonly) ELConfig *config;
@property (readonly) ELLayer *layer;

+ (ELTool *)fromXMLData:(NSXMLElement *)xml;

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type config:(ELConfig *)config;

- (void)useInheritedConfig:(NSString *)key;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (void)run:(ELPlayhead *)playhead;

// Cooperate with ELData protocol

- (void)saveToolConfig:(NSMutableDictionary *)attributes;
- (BOOL)loadToolConfig:(NSXMLElement *)xml;

@end
