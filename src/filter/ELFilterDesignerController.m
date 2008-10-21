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
    
    if( [[knob filter] isKindOfClass:[ELSquareFilter class]] ) {
      squareFilter = (ELSquareFilter *)[knob filter];
      selectedTag = @"square";
    } else {
      squareFilter = [[ELSquareFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 rest:30000 sustain:30000];
    }
    
    if( [[knob filter] isKindOfClass:[ELSquareFilter class]] ) {
      sawFilter = (ELSawFilter *)[knob filter];
      selectedTag = @"saw";
    } else {
      sawFilter = [[ELSawFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 rest:30000 attack:30000 sustain:30000 decay:30000];
    }
    
    if( [[knob filter] isKindOfClass:[ELSquareFilter class]] ) {
      sineFilter = (ELSineFilter *)[knob filter];
      selectedTag = @"saw";
    } else {
      sineFilter = [[ELSineFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0 period:30000];
    }
    
    if( [[knob filter] isKindOfClass:[ELSquareFilter class]] ) {
      listFilter = (ELListFilter *)[knob filter];
      selectedTag = @"list";
    } else {
      listFilter = [[ELListFilter alloc] initEnabled:YES values:[NSArray array]];
    }
    
    if( [[knob filter] isKindOfClass:[ELSquareFilter class]] ) {
      randomFilter = (ELRandomFilter *)[knob filter];
      selectedTag = @"random";
    } else {
      randomFilter = [[ELRandomFilter alloc] initEnabled:YES minimum:0.0 maximum:100.0];
    }
  }
  
  return self;
}

- (void)awakeFromNib {
  if( selectedTag ) {
    [tabView selectTabViewItemWithIdentifier:selectedTag];
  }
}

@synthesize knob;

@synthesize squareFilter;
@synthesize sawFilter;
@synthesize sineFilter;
@synthesize listFilter;
@synthesize randomFilter;

- (IBAction)save:(id)_sender_ {
  [[self window] close];
}

- (IBAction)cancel:(id)_sender_ {
  [[self window] close];
}

@end
