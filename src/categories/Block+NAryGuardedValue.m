//
//  Block+NAryGuardedValue.m
//  Elysium
//
//  Created by Matt Mower on 05/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Block+NAryGuardedValue.h"

@implementation Block (Block_NAryGuardedValue)

- (id)guardedValue:(id)arg1 value:(id)arg2
{
  Array *argArray = [[Array alloc] init];
  [argArray addObject:arg1];
  [argArray addObject:arg2];
  
  FSInterpreterResult *interpreterResult = [self executeWithArguments:argArray]; // We use an Array instead of NSArray because arg1 might be nil
  
  if ([interpreterResult isOk])
  {
    return [interpreterResult result];
  }
  else
  {
    [self showError:[interpreterResult errorMessage]]; // usefull if the call stack is empty
    [interpreterResult inspectBlocksInCallStack];
    return nil;
  }
}

@end
