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
  NSString  *type;
  ELLayer   *layer;
  ELHex     *hex;
  ELConfig  *config;
}

- (id)initWithType:(NSString *)type layer:(ELLayer *)layer hex:(ELHex *)hex config:(ELConfig *)config;

- (void)run:(ELPlayhead *)playhead;

@end
