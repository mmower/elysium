//
//  ELStartTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELStartTool.h"

#import "ELPlayhead.h"

@implementation ELStartTool

- (void)run:(ELPlayhead *)_playhead {
  direction = [[config objectForKey:@"direction"] integerValue];
  ttl = [[config objectForKey:@"ttl"] integerValue];
  
  [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex direction:direction ttl:ttl]];
}

@end
