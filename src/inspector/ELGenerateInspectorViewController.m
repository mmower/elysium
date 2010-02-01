//
//  ELGenerateInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELGenerateInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELGenerateInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELGenerateInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.generate"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"direction"];
  [self bindMode:@"direction"];
  [self bindOsc:@"direction"];
  
  [self bindControl:@"timeToLive"];
  [self bindMode:@"timeToLive"];
  [self bindOsc:@"timeToLive"];
  
  [self bindControl:@"pulseEvery"];
  [self bindMode:@"pulseEvery"];
  [self bindOsc:@"pulseEvery"];
  
  [self bindControl:@"offset"];
  [self bindMode:@"offset"];
  [self bindOsc:@"offset"];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
  
  [self bindTriggerModeControl];
}

- (void)bindTriggerModeControl {
  [triggerModeControl bind:@"selectedIndex" toObject:[self objectController] withKeyPath:@"selection.triggerModeDial.value" options:nil];
}


@end
