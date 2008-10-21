//
//  ELFilterDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFilterDesignerController.h"

#import "ELKnob.h"

#import "ELSquareFilter.h"
#import "ELSawFilter.h"
#import "ELSineFilter.h"
#import "ELListFilter.h"
#import "ELRandomFilter.h"

@implementation ELFilterDesignerController

- (id)initWithKnob:(ELKnob *)_knob_ {
  if( ( self = [self initWithWindowNibName:@"FilterDesigner"] ) ) {
    knob = _knob_;
    
    squareFilter = [[ELSquareFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 rest:30000 sustain:30000];
    sawFilter = [[ELSawFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 rest:30000 attack:30000 sustain:30000 decay:30000];
    sineFilter = [[ELSineFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 period:30000];
    listFilter = [[ELListFilter alloc] initEnabled:YES values:[NSArray array]];
    randomFilter = [[ELRandomFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0];
  }
  
  return self;
}

@synthesize knob;

@end
