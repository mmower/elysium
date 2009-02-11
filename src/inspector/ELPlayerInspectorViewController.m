//
//  ELPlayerInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELPlayerInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELPlayerInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELPlayerInspectorPane"
                                     target:controller
                                       path:@"player"];
}

- (void)awakeFromNib {
  [self bindControl:@"transpose"];
  [self bindMode:@"transpose"];
  [self bindOsc:@"transpose"];
  
  [self bindControl:@"tempo"];
  [self bindMode:@"tempo"];
  [self bindOsc:@"tempo"];
  
  [self bindControl:@"barLength"];
  [self bindMode:@"barLength"];
  [self bindOsc:@"barLength"];
  
  [self bindControl:@"velocity"];
  [self bindMode:@"velocity"];
  [self bindOsc:@"velocity"];
  
  [self bindControl:@"emphasis"];
  [self bindMode:@"emphasis"];
  [self bindOsc:@"emphasis"];
  
  [self bindControl:@"tempoSync"];
  
  [self bindControl:@"noteLength"];
  [self bindMode:@"noteLength"];
  [self bindOsc:@"noteLength"];
  
  [self bindControl:@"timeToLive"];
  [self bindMode:@"timeToLive"];
  [self bindOsc:@"timeToLive"];
  
  [self bindControl:@"pulseEvery"];
  [self bindMode:@"pulseEvery"];
  [self bindOsc:@"pulseEvery"];
  
  [self bindScript:@"willStart"];
  [self bindScript:@"didStart"];
  [self bindScript:@"willStop"];
  [self bindScript:@"didStop"];
}

@end
