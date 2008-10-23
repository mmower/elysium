//
//  ELFilterDesignerController.m
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFilterDesignerController.h"

#import "ELRangedKnob.h"

#import "ELSquareFilter.h"
#import "ELSawFilter.h"
#import "ELSineFilter.h"
#import "ELListFilter.h"
#import "ELRandomFilter.h"

@implementation ELFilterDesignerController

- (id)initWithKnob:(ELRangedKnob *)_knob_ {
  if( ( self = [self initWithWindowNibName:@"FilterDesigner"] ) ) {
    knob = _knob_;
    
    NSLog( @"Knob = %@, Min=%f, Max=%f, Stepping=%f, Filter = %@", knob, [knob minimum], [knob maximum], [knob stepping], [knob filter] );
    
    if( [knob filter] ) {
      selectedTag = [[knob filter] type];
    } else {
      selectedTag = nil;
    }
    
    if( [selectedTag isEqualToString:@"Square"] ) {
      squareFilter = (ELSquareFilter *)[knob filter];
    } else {
      squareFilter = [[ELSquareFilter alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] rest:30000 sustain:30000];
    }
    
    if( [selectedTag isEqualToString:@"Saw"] ) {
      sawFilter = (ELSawFilter *)[knob filter];
    } else {
      sawFilter = [[ELSawFilter alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] rest:30000 attack:30000 sustain:30000 decay:30000];
    }
    
    if( [selectedTag isKindOfClass:@"Sine"] ) {
      sineFilter = (ELSineFilter *)[knob filter];
    } else {
      sineFilter = [[ELSineFilter alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum] period:30000];
    }
    
    if( [selectedTag isEqualToString:@"List"] ) {
      listFilter = (ELListFilter *)[knob filter];
    } else {
      listFilter = [[ELListFilter alloc] initEnabled:YES values:[NSArray array]];
    }
    
    if( [selectedTag isEqualToString:@"Random"] ) {
      randomFilter = (ELRandomFilter *)[knob filter];
    } else {
      randomFilter = [[ELRandomFilter alloc] initEnabled:YES minimum:[knob minimum] maximum:[knob maximum]];
    }
    
    NSLog( @"SelectedTag = %@", selectedTag );
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
  NSLog( @"Save & Close" );
  
  NSString *tabId = (NSString *)[[tabView selectedTabViewItem] identifier];
  NSLog( @"Tab id = %@", tabId );
  if( [tabId isEqualToString:@"Square"] ) {
    [knob setFilter:squareFilter];
  } else if( [tabId isEqualToString:@"Saw"] ) {
    [knob setFilter:sawFilter];
  } else if( [tabId isEqualToString:@"Sine"] ) {
    [knob setFilter:sineFilter];
  } else if( [tabId isEqualToString:@"List"] ) {
    [knob setFilter:listFilter];
  } else if( [tabId isEqualToString:@"Random"] ) {
    [knob setFilter:randomFilter];
  }
  
  [self close];
}

- (IBAction)cancel:(id)_sender_ {
  [self close];
}

@end
