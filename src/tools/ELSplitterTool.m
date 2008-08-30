//
//  ELSplitterTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSplitterTool.h"

#import "ELLayer.h"
#import "ELPlayhead.h"

@implementation ELSplitterTool

+ (ELSplitterTool *)new {
  return [[ELSplitterTool alloc] init];
}

- (id)init {
  if( self = [super initWithType:@"splitter"] ) {
    // NOP
  }
  
  return self;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [_playhead setPosition:nil];
    for( int direction = N; direction <= NW; direction++ ) {
      if( direction != [_playhead direction] ) {
        [layer addPlayhead:[[ELPlayhead alloc] initWithPosition:hex
                                                      direction:direction
                                                            TTL:[_playhead TTL]]];
      }
    }
    return YES;
  } else {
    return NO;
  }
}

@end
