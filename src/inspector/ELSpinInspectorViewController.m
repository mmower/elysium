//
//  ELSpinInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSpinInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELSpinInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELSpinInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.spin"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
  [self bindControl:@"stepping"];
  [self bindMode:@"stepping"];
  [self bindOsc:@"stepping"];
  
  [self bindControl:@"clockwise"];
}

@end
