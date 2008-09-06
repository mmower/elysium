//
//  ELPlayhead.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELLayer;
@class ELHex;

@interface ELPlayhead : NSObject {
  ELLayer   *layer;
  ELHex     *position;
  Direction direction;
  int       TTL;
}

- (id)initWithPosition:(ELHex *)position direction:(Direction)direction TTL:(int)TTL;

@property ELHex *position;
@property Direction direction;
@property (readonly) BOOL isDead;
@property (readonly) int TTL;

- (void)advance;
- (void)cleanup;
- (void)kill;
  
@end
