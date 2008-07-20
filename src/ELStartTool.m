//
//  ELStartTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELStartTool.h"

#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELStartTool

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                direction:[config integerForKey:@"direction"]
                                                      ttl:[config integerForKey:@"ttl"]]];
}

@end
