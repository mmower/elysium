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

#pragma mark Object initialization

- (id)initWithPosition:(ELCell *)position direction:(Direction)direction TTL:(int)ttl {
  if( ( self = [super init] ) ) {
    [self setPosition:position];
    [self setParent:position];
    [self setDirection:direction];
    [self setTTL:ttl];
    [self setIsNew:YES];
    [self setSkipCount:0];
  }
  
  return self;
}


#pragma mark Properties

@synthesize skipCount = _skipCount;
@synthesize parent = _parent;
@synthesize isNew = _isNew;
@synthesize TTL = _TTL;

@synthesize position = _position;

- (void)setPosition:(ELCell *)position {
  [_position playheadLeaving:self];

  if( position ) {
    NSAssert( [position isKindOfClass:[ELCell class]], @"Class error <argument>" );
    _position = position;
    [_position playheadEntering:self];
  } else {
    _position = nil;
  }
}

@synthesize direction = _direction;

@dynamic isDead;

- (BOOL)isDead {
  return [self position] == nil || [self TTL] < 1;
}


#pragma mark Object behaviour

- (void)advance {
  ELCell *position = [self position];
  
  [position setPlayheadEntered:NO];
  
  while( [self skipCount] ) {
    position = [position neighbour:[self direction]];
    [self setSkipCount:[self skipCount]-1];
  }
  
  position = [position neighbour:[self direction]];
  
  [self setPosition:position];
  [self setTTL:[self TTL]-1];
  [self setIsNew:NO];
}


- (void)kill {
  [self setTTL:0];
}


- (void)cleanup {
  if( [self isDead] ) {
    [self setPosition:nil];
  }
}


@end
