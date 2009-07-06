//
//  ELRandomOscillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELRandomOscillator.h"

@implementation ELRandomOscillator

- (NSString *)type {
  return @"Random";
}


- (int)generate {
  long lrange = ( [self range] + 1 ) * 100;
  return [self minimum] + ( ( random() % lrange ) / 100 );
}


- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
}


- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                minimum:[self minimum]
                                                maximum:[self maximum]];
}


@end
