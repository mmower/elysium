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
    [self setPosition:_position];
    direction = _direction;
    ttl       = _ttl;
  }
  
  return self;
}

- (ELHex *)position {
  return position;
}

- (void)setPosition:(ELHex *)_position {
  [position playheadLeaving:self];
  position = _position;
  [position playheadEntering:self];
}

- (void)advance {
  [self setPosition:[position neighbour:direction]];
  ttl--;
}

- (BOOL)isDead {
  return position == nil || ttl < 1;
}

@end
