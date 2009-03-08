//
//  ELPlayhead.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELCell;
@class ELLayer;

@interface ELPlayhead : NSObject {
  ELLayer   *layer;
  ELCell    *parent;
  ELCell    *position;
  Direction direction;
  int       skipCount;
  int       TTL;
  BOOL      isNew;
}

- (id)initWithPosition:(ELCell *)position direction:(Direction)direction TTL:(int)TTL;

@property ELCell *position;
@property ELCell *parent;
@property Direction direction;
@property int skipCount;
@property (readonly) BOOL isDead;
@property (readonly) int TTL;
@property (readonly) BOOL isNew;

- (void)advance;
- (void)cleanup;
- (void)kill;

  
@end
