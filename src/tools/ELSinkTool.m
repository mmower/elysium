//
//  ELSinkTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSinkTool.h"

#import "ELPlayhead.h"

@implementation ELSinkTool

+ (ELSinkTool *)new {
  return [[ELSinkTool alloc] init];
}

- (id)init {
  if( self = [super initWithType:@"sink"] ) {
    // NOP
  }
  
  return self;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    [_playhead setPosition:nil];
    return YES;
  } else {
    return NO;
  }
}

@end
