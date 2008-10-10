//
//  String+AsRubyBlock.m
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "String+AsRubyBlock.h"

#import "RubyBlock.h"

@implementation NSString (String_AsRubyBlock)

- (RubyBlock *)asRubyBlock {
  return [[RubyBlock alloc] initWithSource:self];
}

@end
