//
//  ELPlayhead.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELHex.h"
#import "ELPlayhead.h"

@implementation ELPlayhead

- (id)initWithPosition:(ELHex *)_position direction:(Direction)_direction ttl:(int)_ttl {
  if( self = [super init] ) {
    position  = _position;
    direction = _direction;
    ttl       = _ttl;
  }
  
  return self;
}

- (void)advance {
  position = [position neighbour:direction];
  ttl--;
}

- (BOOL)isDead {
  return position == nil || ttl < 1;
}

@end
