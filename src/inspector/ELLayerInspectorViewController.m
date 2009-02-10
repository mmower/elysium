//
//  ELLayerInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELLayerInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELLayerInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELLayerInspectorPane"
                                     target:controller
                                       path:@"layer"];
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
  [self bindMode:@"tempoSync"];
  
  [self bindControl:@"noteLength"];
  [self bindMode:@"noteLength"];
  [self bindOsc:@"noteLength"];
  
  [self bindControl:@"timeToLive"];
  [self bindMode:@"timeToLive"];
  [self bindOsc:@"timeToLive"];
  
  [self bindControl:@"pulseEvery"];
  [self bindMode:@"pulseEvery"];
  [self bindOsc:@"pulseEvery"];  
}

@end
