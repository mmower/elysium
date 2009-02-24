//
//  ELSkipInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 23/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSkipInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELSkipInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELSkipInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.skip"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
  [self bindControl:@"skipCount"];
  [self bindMode:@"skipCount"];
  [self bindOsc:@"skipCount"];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
}


@end
