//
//  ELMutexGroup.m
//  Elysium
//
//  Created by Matt Mower on 30/09/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELMutexGroup.h"


#import "ELToken.h"


@interface ELMutexGroup (PrivateMethods)

- (ELToken *)selectFirst;
- (ELToken *)selectRoundRobin;
- (ELToken *)selectRandom;

@end


@implementation ELMutexGroup


#pragma mark Initializers

- (id)init {
  return [self initWithMode:mgRoundRobin];
}


- (id)initWithMode:(ELMutexGroupMode)mode {
  if( ( self = [super init] ) ) {
    _mode    = mode;
    _members = [[NSMutableArray alloc] initWithCapacity:7];
    _last    = 0;
  }
  
  return self;
}


#pragma mark Properties

@synthesize mode    = _mode;
@synthesize members = _members;


#pragma mark Behaviours

- (void)reset {
  _last = 0;
}


- (ELToken *)selectAction {
  switch( [self mode] ) {
    case mgFirst:
      return [self selectFirst];
    case mgRoundRobin:
      return [self selectRoundRobin];
    case mgRandom:
      return [self selectRandom];
  }
  
  // Can't happen
  NSAssert( NO, @"Shouldn't reach here!" );
  return nil;
}


- (ELToken *)selectFirst {
  return [[self members] objectAtIndex:0];
}


- (ELToken *)selectRoundRobin {
  ELToken *selected = [[self members] objectAtIndex:_last];
  _last += 1;
  if( _last >= [[self members] count] ) {
    _last = 0;
  }
  return selected;
}


- (ELToken *)selectRandom {
  return nil;
  // return [[self members] objectAtIndex:[random() % [[self members] count]]];
}


@end
