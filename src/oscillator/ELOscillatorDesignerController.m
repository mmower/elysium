//
//  ELOscillatorDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELOscillatorDesignerController.h"

#import "ELDial.h"
#import "ELSquareOscillator.h"
#import "ELSawOscillator.h"
#import "ELSineOscillator.h"
#import "ELRampOscillator.h"
#import "ELSequenceOscillator.h"
#import "ELRandomOscillator.h"

#import "ELInspectorController.h"

#import "ELPlayer.h"

@implementation ELOscillatorDesignerController

- (id)initWithDial:(ELDial *)theDial controller:(ELInspectorController *)theController {
  if( ( self = [self initWithWindowNibName:@"OscillatorDesigner"] ) ) {
    [self setDial:theDial];
    [self setController:theController];
    [self setupOscillators];
  }
  
  return self;
}

- (void)awakeFromNib {
  if( selectedTag ) {
    [tabView selectTabViewItemWithIdentifier:selectedTag];
  }
}

- (void)windowWillClose:(NSNotification *)notification {
  [[self controller] finishedEditingOscillatorForDial:[self dial]];
}

@synthesize controller;

@synthesize dial;

@synthesize squareOscillator;
@synthesize sawOscillator;
@synthesize sineOscillator;
@synthesize rampOscillator;
@synthesize sequenceOscillator;
@synthesize randomOscillator;

- (IBAction)saveOscillator:(id)_sender_ {
  NSString *tabId = (NSString *)[[tabView selectedTabViewItem] identifier];
  if( [tabId isEqualToString:@"Square"] ) {
    [dial setOscillator:squareOscillator];
  } else if( [tabId isEqualToString:@"Saw"] ) {
    [dial setOscillator:sawOscillator];
  } else if( [tabId isEqualToString:@"Sine"] ) {
    [dial setOscillator:sineOscillator];
  } else if( [tabId isEqualToString:@"Ramp"] ) {
    [dial setOscillator:rampOscillator];
  } else if( [tabId isEqualToString:@"Sequence"] ) {
    [dial setOscillator:sequenceOscillator];
  } else if( [tabId isEqualToString:@"Random"] ) {
    [dial setOscillator:randomOscillator];
  }
  
  if( [dial oscillator] ) {
    [[dial oscillator] start];
    [dial setMode:dialDynamic];
  }
  
  [self close];
}

- (IBAction)cancelOscillator:(id)sender {
  [self close];
}

- (IBAction)removeOscillator:(id)sender {
  [[dial oscillator] stop];
  [dial setOscillator:nil];
  [self close];
}

- (void)setupOscillators {
  if( [dial oscillator] ) {
    selectedTag = [[dial oscillator] type];
  } else {
    selectedTag = nil;
  }
  
  if( [selectedTag isEqualToString:@"Square"] ) {
    [self setSquareOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setSquareOscillator:[[ELSquareOscillator alloc] initEnabled:YES minimum:[dial min] maximum:[dial max] rest:30000 sustain:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Saw"] ) {
    [self setSawOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setSawOscillator:[[ELSawOscillator alloc] initEnabled:YES minimum:[dial min] maximum:[dial max] rest:30000 attack:30000 sustain:30000 decay:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Sine"] ) {
    [self setSineOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setSineOscillator:[[ELSineOscillator alloc] initEnabled:YES minimum:[dial min] maximum:[dial max] period:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Ramp"] ) {
    [self setRampOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setRampOscillator:[[ELRampOscillator alloc] initEnabled:YES minimum:[dial min] maximum:[dial max] period:30000 rising:YES]];
  }
  
  if( [selectedTag isEqualToString:@"Sequence"] ) {
    [self setSequenceOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setSequenceOscillator:[[ELSequenceOscillator alloc] initEnabled:YES values:[NSArray array]]];
  }
  
  if( [selectedTag isEqualToString:@"Random"] ) {
    [self setRandomOscillator:[[dial oscillator] mutableCopy]];
  } else {
    [self setRandomOscillator:[[ELRandomOscillator alloc] initEnabled:YES minimum:[dial min] maximum:[dial max]]];
  }
}

- (void)edit {
  [self setupOscillators];
  [self showWindow:self];
}

@end
