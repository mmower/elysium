//
//  ELNoteInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELNoteInspectorViewController.h"

#import "ELInspectorController.h"

@implementation ELNoteInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)controller {
  return [super initWithInspectorController:controller
                                    nibName:@"ELNoteInspectorPane"
                                     target:controller
                                       path:@"cell.tokens.note"];
}

- (void)awakeFromNib {
  [self bindControl:@"enabled"];
  
  [self bindControl:@"p"];
  [self bindMode:@"p"];
  [self bindOsc:@"p"];
  
  [self bindControl:@"gate"];
  [self bindMode:@"gate"];
  [self bindOsc:@"gate"];
  
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
  
  [self bindControl:@"ghosts"];
  [self bindMode:@"ghosts"];
  [self bindOsc:@"ghosts"];
  
  [self bindControl:@"override"];
  
  [self bindTriadControl];
  
  [self bindOverrideControls];
  
  [self bindScript:@"willRun"];
  [self bindScript:@"didRun"];
}

- (void)bindTriadControl {
  [triadControl bind:@"selectedIndex" toObject:[self objectController] withKeyPath:@"selection.triadDial.value" options:nil];
}

- (void)bindOverrideControls {
  [channelOverrideSelectorView bind:@"hidden"
                           toObject:[self objectController]
                        withKeyPath:@"selection.overrideDial.value"
                            options:[NSDictionary dictionaryWithObject:NSNegateBooleanTransformerName forKey:NSValueTransformerNameBindingOption]];
  
  [self bindMode:@"chan1Override"];
  [self bindControl:@"chan1Override"];
  [self bindOsc:@"chan1Override"];
  [self bindMode:@"chan2Override"];
  [self bindControl:@"chan2Override"];
  [self bindOsc:@"chan2Override"];
  [self bindMode:@"chan3Override"];
  [self bindControl:@"chan3Override"];
  [self bindOsc:@"chan3Override"];
  [self bindMode:@"chan4Override"];
  [self bindControl:@"chan4Override"];
  [self bindOsc:@"chan4Override"];
  [self bindMode:@"chan5Override"];
  [self bindControl:@"chan5Override"];
  [self bindOsc:@"chan5Override"];
  [self bindMode:@"chan6Override"];
  [self bindControl:@"chan6Override"];
  [self bindOsc:@"chan6Override"];
  [self bindMode:@"chan7Override"];
  [self bindControl:@"chan7Override"];
  [self bindOsc:@"chan7Override"];
  [self bindMode:@"chan8Override"];
  [self bindControl:@"chan8Override"];
  [self bindOsc:@"chan8Override"];
}

@end
