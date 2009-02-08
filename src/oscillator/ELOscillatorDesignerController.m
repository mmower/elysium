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
#import "ELSequenceOscillator.h"
#import "ELRandomOscillator.h"

#import "ELInspectorController.h"

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
  
  // Determine whether the cell formatters for the fields should allow
  // decimals for float values or not
  // for( NSTabViewItem *item in [tabView tabViewItems] ) {
  //   [self setView:[item view] cellsAllowFloats:[knob encodesType:@encode(float)]];
  // }
  
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
@synthesize sequenceOscillator;
@synthesize randomOscillator;

- (void)setView:(NSView *)_view_ cellsAllowFloats:(BOOL)_allowFloats_ {
  // for( NSView *view in [_view_ subviews] ) {
  //   [self setView:view cellsAllowFloats:_allowFloats_];
  // }
  
  id cell, formatter;
  if( [_view_ isKindOfClass:[NSControl class]] ) {
    if( ( cell = [(NSControl *)_view_ cell] ) ) {
      if( ( formatter = [cell formatter] )   ) {
        if( [formatter isKindOfClass:[NSNumberFormatter class]] ) {
          [formatter setAllowsFloats:_allowFloats_];
        }
      }
    }
  }
}

- (IBAction)saveOscillator:(id)_sender_ {
  NSString *tabId = (NSString *)[[tabView selectedTabViewItem] identifier];
  if( [tabId isEqualToString:@"Square"] ) {
    [dial setOscillator:squareOscillator];
  } else if( [tabId isEqualToString:@"Saw"] ) {
    [dial setOscillator:sawOscillator];
  } else if( [tabId isEqualToString:@"Sine"] ) {
    [dial setOscillator:sineOscillator];
  } else if( [tabId isEqualToString:@"Sequence"] ) {
    [dial setOscillator:sequenceOscillator];
  } else if( [tabId isEqualToString:@"Random"] ) {
    [dial setOscillator:randomOscillator];
  }
  
  if( [dial oscillator] ) {
    [dial setMode:dialDynamic];
  }
  
  [self close];
}

- (IBAction)cancelOscillator:(id)_sender_ {
  [self close];
}

- (IBAction)removeOscillator:(id)_sender_ {
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
