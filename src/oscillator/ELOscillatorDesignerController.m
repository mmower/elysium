//
//  ELOscillatorDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELOscillatorDesignerController.h"

#import "ELRangedKnob.h"

#import "ELSquareOscillator.h"
#import "ELSawOscillator.h"
#import "ELSineOscillator.h"
#import "ELSequenceOscillator.h"
#import "ELRandomOscillator.h"

@implementation ELOscillatorDesignerController

- (id)initWithKnob:(ELRangedKnob *)_knob_ {
  if( ( self = [self initWithWindowNibName:@"OscillatorDesigner"] ) ) {
    knob = _knob_;
    [self setupOscillators];
  }
  
  return self;
}

- (void)awakeFromNib {
  
  // Determine whether the cell formatters for the fields should allow
  // decimals for float values or not
  for( NSTabViewItem *item in [tabView tabViewItems] ) {
    [self setView:[item view] cellsAllowFloats:[knob encodesType:@encode(float)]];
  }
  
  if( selectedTag ) {
    [tabView selectTabViewItemWithIdentifier:selectedTag];
  }
}

@synthesize knob;

@synthesize squareOscillator;
@synthesize sawOscillator;
@synthesize sineOscillator;
@synthesize sequenceOscillator;
@synthesize randomOscillator;

- (void)setView:(NSView *)_view_ cellsAllowFloats:(BOOL)_allowFloats_ {
  for( NSView *view in [_view_ subviews] ) {
    [self setView:view cellsAllowFloats:_allowFloats_];
  }
  
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
    [knob setOscillator:squareOscillator];
  } else if( [tabId isEqualToString:@"Saw"] ) {
    [knob setOscillator:sawOscillator];
  } else if( [tabId isEqualToString:@"Sine"] ) {
    [knob setOscillator:sineOscillator];
  } else if( [tabId isEqualToString:@"Sequence"] ) {
    [knob setOscillator:sequenceOscillator];
  } else if( [tabId isEqualToString:@"Random"] ) {
    [knob setOscillator:randomOscillator];
  }
  
  [knob setOscillatorController:nil];
  [self close];
}

- (IBAction)cancelOscillator:(id)_sender_ {
  [knob setOscillatorController:nil];
  [self close];
}

- (IBAction)removeOscillator:(id)_sender_ {
  [knob setOscillator:nil];
  [self close];
}

- (void)setupOscillators {
  NSLog( @"setupOscillators" );
  if( [knob oscillator] ) {
    selectedTag = [[knob oscillator] type];
  } else {
    selectedTag = nil;
  }
  
  if( [selectedTag isEqualToString:@"Square"] ) {
    [self setSquareOscillator:[[knob oscillator] mutableCopy]];
  } else {
    [self setSquareOscillator:[[ELSquareOscillator alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] rest:30000 sustain:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Saw"] ) {
    [self setSawOscillator:[[knob oscillator] mutableCopy]];
  } else {
    [self setSawOscillator:[[ELSawOscillator alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] rest:30000 attack:30000 sustain:30000 decay:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Sine"] ) {
    [self setSineOscillator:[[knob oscillator] mutableCopy]];
  } else {
    [self setSineOscillator:[[ELSineOscillator alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] period:30000]];
  }
  
  if( [selectedTag isEqualToString:@"Sequence"] ) {
    [self setSequenceOscillator:[[knob oscillator] mutableCopy]];
  } else {
    [self setSequenceOscillator:[[ELSequenceOscillator alloc] initEnabled:YES values:[NSArray array]]];
  }
  
  if( [selectedTag isEqualToString:@"Random"] ) {
    [self setRandomOscillator:[[knob oscillator] mutableCopy]];
  } else {
    [self setRandomOscillator:[[ELRandomOscillator alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum]]];
  }
}

- (void)edit {
  [self setupOscillators];
  [self showWindow:self];
}

@end
