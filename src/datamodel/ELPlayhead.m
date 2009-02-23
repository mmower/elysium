//
//  ELPlayhead.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELHex.h"
#import "ELPlayhead.h"

@implementation ELPlayhead

- (id)initWithPosition:(ELHex *)_position_ direction:(Direction)_direction_ TTL:(int)_TTL_ {
  if( ( self = [super init] ) ) {
    [self setPosition:_position_];
    [self setParent:_position_];
    
    direction = _direction_;
    TTL       = _TTL_;
    skipCount = 0;
    isNew     = YES;
  }
  
  return self;
}

@synthesize TTL;
@synthesize skipCount;
@dynamic position;
@synthesize parent;
@synthesize isNew;

- (ELHex *)position {
  return position;
}

- (void)setPosition:(ELHex *)newPosition {
  [position playheadLeaving:self];

  if( newPosition ) {
    NSAssert( [newPosition isKindOfClass:[ELHex class]], @"Class error <argument>" );
    position = newPosition;
    [position playheadEntering:self];
  } else {
    position = nil;
  }
}

@synthesize direction;

- (void)advance {
  ELHex *newPosition = position;
  
  while( skipCount ) {
    newPosition = [newPosition neighbour:direction];
    skipCount--;
  }
  
  newPosition = [newPosition neighbour:direction];
  
  [self setPosition:newPosition];
  TTL--;
  isNew = NO;
}

@dynamic isDead;

- (void)kill {
  TTL = 0;
}

- (BOOL)isDead {
  return position == nil || TTL < 1;
}

- (void)cleanup {
  if( [self isDead] ) {
    [self setPosition:nil];
  }
}

@end
