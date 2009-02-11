//
//  ELSplitInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSplitInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELSplitInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELSplitInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.split"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
  [self bindControl:@"bounceBack"];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
}

@end
