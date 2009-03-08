//
//  ELPlayhead.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELCell.h"
#import "ELPlayhead.h"

@implementation ELPlayhead

- (id)initWithPosition:(ELCell *)aPosition direction:(Direction)aDirection TTL:(int)aTTL {
  if( ( self = [super init] ) ) {
    [self setPosition:aPosition];
    [self setParent:aPosition];
    
    direction = aDirection;
    TTL       = aTTL;
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

- (ELCell *)position {
  return position;
}

- (void)setPosition:(ELCell *)newPosition {
  [position playheadLeaving:self];

  if( newPosition ) {
    NSAssert( [newPosition isKindOfClass:[ELCell class]], @"Class error <argument>" );
    position = newPosition;
    [position playheadEntering:self];
  } else {
    position = nil;
  }
}

@synthesize direction;

- (void)advance {
  ELCell *newPosition = position;
  
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
