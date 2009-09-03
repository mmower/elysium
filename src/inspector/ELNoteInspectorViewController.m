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
  
  [self bindDial:@"p"];
  [self bindDial:@"gate"];
  [self bindDial:@"velocity"];
  [self bindDial:@"emphasis"];
  
  // [self bindControl:@"tempoSync"];
  
  [self bindDial:@"noteLength"];
  [self bindDial:@"ghosts"];
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
  
  [self bindControl:@"override"];
  [self bindDial:@"chan1Override"];
  [self bindDial:@"chan2Override"];
  [self bindDial:@"chan3Override"];
  [self bindDial:@"chan4Override"];
  [self bindDial:@"chan5Override"];
  [self bindDial:@"chan6Override"];
  [self bindDial:@"chan7Override"];
  [self bindDial:@"chan8Override"];
}

@end
