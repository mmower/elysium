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

#import <LMDial/LMDialView.h>

@implementation ELOscillatorDesignerController

- (id)initWithDial:(ELDial *)dial controller:(ELInspectorController *)controller {
  if( ( self = [self initWithWindowNibName:@"OscillatorDesigner"] ) ) {
    _dial = dial;
    [self setController:controller];
  }
  
  return self;
}

- (void)awakeFromNib {
  [squareLFOMinDial setBoundsChecking:NO];
  [squareLFOMaxDial setBoundsChecking:NO];
  [sawLFOMinDial setBoundsChecking:NO];
  [sawLFOMaxDial setBoundsChecking:NO];
  [sineLFOMinDial setBoundsChecking:NO];
  [sineLFOMaxDial setBoundsChecking:NO];
  [rampLFOMinDial setBoundsChecking:NO];
  [rampLFOMaxDial setBoundsChecking:NO];
  
  [self setupOscillators];
  if( selectedTag ) {
    [tabView selectTabViewItemWithIdentifier:selectedTag];
  }
  
  [squareLFOMinDial setBoundsChecking:YES];
  [squareLFOMaxDial setBoundsChecking:YES];
  [sawLFOMinDial setBoundsChecking:YES];
  [sawLFOMaxDial setBoundsChecking:YES];
  [sineLFOMinDial setBoundsChecking:YES];
  [sineLFOMaxDial setBoundsChecking:YES];
  [rampLFOMinDial setBoundsChecking:YES];
  [rampLFOMaxDial setBoundsChecking:YES];
}

- (void)windowWillClose:(NSNotification *)notification {
  [[self controller] finishedEditingOscillatorForDial:_dial];
}

@synthesize controller         = _controller;
@synthesize squareOscillator   = _squareOscillator;
@synthesize sawOscillator      = _sawOscillator;
@synthesize sineOscillator     = _sineOscillator;
@synthesize rampOscillator     = _rampOscillator;
@synthesize sequenceOscillator = _sequenceOscillator;
@synthesize randomOscillator   = _randomOscillator;

- (IBAction)saveOscillator:(id)sender {
  NSString *tabId = (NSString *)[[tabView selectedTabViewItem] identifier];
  if( [tabId isEqualToString:@"Square"] ) {
    [_dial setOscillator:[self squareOscillator]];
  } else if( [tabId isEqualToString:@"Saw"] ) {
    [_dial setOscillator:[self sawOscillator]];
  } else if( [tabId isEqualToString:@"Sine"] ) {
    [_dial setOscillator:[self sineOscillator]];
  } else if( [tabId isEqualToString:@"Ramp"] ) {
    [_dial setOscillator:[self rampOscillator]];
  } else if( [tabId isEqualToString:@"Sequence"] ) {
    [_dial setOscillator:[self sequenceOscillator]];
  } else if( [tabId isEqualToString:@"Random"] ) {
    [_dial setOscillator:[self randomOscillator]];
  }
  
  if( [_dial oscillator] ) {
    [[_dial oscillator] start];
    [_dial setMode:dialDynamic];
  }
  
  [self close];
}

- (IBAction)cancelOscillator:(id)sender {
  [self close];
}

- (IBAction)removeOscillator:(id)sender {
  [[_dial oscillator] stop];
  [_dial setOscillator:nil];
  [self close];
}

- (void)setupOscillators {
  if( [_dial oscillator] ) {
    selectedTag = [[_dial oscillator] type];
  } else {
    selectedTag = nil;
  }
  
  if( [selectedTag isEqualToString:@"Square"] ) {
    [self setSquareOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setSquareOscillator:[[ELSquareOscillator alloc] initEnabled:YES minimum:[_dial min] maximum:[_dial max] rest:30000 sustain:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Saw"] ) {
    [self setSawOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setSawOscillator:[[ELSawOscillator alloc] initEnabled:YES minimum:[_dial min] maximum:[_dial max] rest:30000 attack:30000 sustain:30000 decay:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Sine"] ) {
    [self setSineOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setSineOscillator:[[ELSineOscillator alloc] initEnabled:YES minimum:[_dial min] maximum:[_dial max] period:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Ramp"] ) {
    [self setRampOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setRampOscillator:[[ELRampOscillator alloc] initEnabled:YES minimum:[_dial min] maximum:[_dial max] period:30000 rising:YES]];
  }
  
  if( [selectedTag isEqualToString:@"Sequence"] ) {
    [self setSequenceOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setSequenceOscillator:[[ELSequenceOscillator alloc] initEnabled:YES values:[NSArray array]]];
  }
  
  if( [selectedTag isEqualToString:@"Random"] ) {
    [self setRandomOscillator:[[_dial oscillator] mutableCopy]];
  } else {
    [self setRandomOscillator:[[ELRandomOscillator alloc] initEnabled:YES minimum:[_dial min] maximum:[_dial max]]];
  }
}

- (void)edit {
  [self showWindow:self];
}


@end
