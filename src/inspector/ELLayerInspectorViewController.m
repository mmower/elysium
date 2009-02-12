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
  [enabledControl bind:@"value" toObject:[self objectController] withKeyPath:@"selection.enabledDial.value" options:nil];
  
  [midiChannelPopup bind:@"selectedValue" toObject:[self objectController] withKeyPath:@"selection.channelDial.value" options:nil];
  
  [keyPopup bind:@"content" toObject:[self objectController] withKeyPath:@"selection.key.allKeys" options:nil];
  [keyPopup bind:@"selectedObject" toObject:[self objectController] withKeyPath:@"selection.key" options:nil];
  
  [self bindDial:@"transpose"];
  [self bindDial:@"tempo"];
  [self bindDial:@"barLength"];
  [self bindDial:@"velocity"];
  [self bindDial:@"emphasis"];
  
  [self bindControl:@"tempoSync"];
  [self bindMode:@"tempoSync"];
  
  [self bindDial:@"noteLength"];
  [self bindDial:@"timeToLive"];
  [self bindDial:@"pulseEvery"];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
}

@end
