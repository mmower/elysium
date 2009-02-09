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
  long lrange = ( range + 1 ) * 100;
  return minimum + ( ( random() % lrange ) / 100 );
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                                  maximum:[self maximum]];
}

@end
