//
//  ELRotorTool.m
//  Elysium
//
//  Created by Matt Mower on 09/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRotorTool.h"

#import "ELHex.h"
#import "ELPlayhead.h"
#import "ELStartTool.h"
#import "ELRicochetTool.h"

@implementation ELRotorTool

+ (ELRotorTool *)new {
  return [[ELRotorTool alloc] init];
}

- (id)init {
  if( self = [super initWithType:@"rotor"] ) {
    // NOP
  }
  
  return self;
}

- (BOOL)run:(ELPlayhead *)_playhead {
  if( [super run:_playhead] ) {
    if( [[_playhead position] toolOfType:@"ricochet"] ) {
      ELRicochetTool *tool = (ELRicochetTool *)[[_playhead position] toolOfType:@"ricochet"];
      [tool setDirection:([tool direction]+1 % 6)];
    } else if( [[_playhead position] toolOfType:@"start"] ) {
      ELStartTool *tool = (ELStartTool *)[[_playhead position] toolOfType:@"start"];
      [tool setDirection:([tool direction]+1 % 6)];
    }
    return YES;
  } else {
    return NO;
  }
}

@end
