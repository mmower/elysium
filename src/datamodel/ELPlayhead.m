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

- (id)initWithPosition:(ELHex *)_position direction:(Direction)_direction TTL:(int)_TTL {
  if( self = [super init] ) {
    [self setPosition:_position];
    direction = _direction;
    TTL       = _TTL;
  }
  
  return self;
}

@synthesize TTL;
@dynamic position;

- (ELHex *)position {
  return position;
}

- (void)setPosition:(ELHex *)_position {
  [position playheadLeaving:self];
  position = _position;
  [position playheadEntering:self];
}

@synthesize direction;

- (void)advance {
  [self setPosition:[position neighbour:direction]];
  TTL--;
}

@dynamic isDead;

- (BOOL)isDead {
  return position == nil || TTL < 1;
}

- (void)cleanup {
  if( [self isDead] ) {
    [self setPosition:nil];
  }
}

@end
