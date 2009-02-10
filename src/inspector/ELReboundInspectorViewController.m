//
//  ELReboundInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELReboundInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELReboundInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELReboundInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.rebound"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
  [self bindControl:@"direction"];
  [self bindMode:@"direction"];
  [self bindOsc:@"direction"];
}

@end
