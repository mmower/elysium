//
//  ElysiumController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ElysiumController.h"

@implementation ElysiumController

- (void)awakeFromNib {
  NSLog( @"I have arisen!" );
  
  [debugOutput insertText:@"We are awake!"];
  
}

@end
