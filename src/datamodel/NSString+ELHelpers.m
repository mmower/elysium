//
//  NSString+ELHelpers.m
//  Elysium
//
//  Created by Matt Mower on 11/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "NSString+ELHelpers.h"

@implementation NSString (NSString_ELHelpers)

- (NSString *)initialCapitalString {
  return [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1] ];
}

@end
