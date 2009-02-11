//
//  ELAbsorbInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELAbsorbInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELAbsorbInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELAbsorbInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.absorb"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
}

@end
