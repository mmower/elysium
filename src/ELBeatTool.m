//
//  ELBeatTool.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELBeatTool.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELBeatTool

- (void)run:(ELPlayhead *)_playhead {
  [super run:_playhead];
  [layer playNote:[[_playhead position] note]
         velocity:[config integerForKey:@"velocity"]
         duration:[config floatForKey:@"duration"]];
}

@end
