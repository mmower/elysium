//
//  ELTool.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELLayer;
@class ELConfig;
@class ELPlayhead;

@interface ELTool : NSObject {
  NSString  *toolType;
  ELLayer   *layer;
  ELHex     *hex;
  ELConfig  *config;
}

@property (readonly) NSString *toolType;
@property (readonly) ELConfig *config;

- (id)initWithType:(NSString *)type;
- (id)initWithType:(NSString *)type config:(ELConfig *)config;

- (void)addedToLayer:(ELLayer *)layer atPosition:(ELHex *)hex;
- (void)removedFromLayer:(ELLayer *)layer;

- (void)run:(ELPlayhead *)playhead;

@end
