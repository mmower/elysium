//
//  ELPlayhead.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELLayer;
@class ELHex;

@interface ELPlayhead : NSObject {
  ELLayer   *layer;
  ELHex     *position;
  Direction direction;
  int       ttl;
}

- (id)initWithPosition:(ELHex *)position direction:(Direction)direction ttl:(int)ttl;

- (ELHex *)position;
- (void)advance;
- (BOOL)isDead;
  
@end
