//
//  ELFilterDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELRangedKnob;
@class ELSquareFilter;
@class ELSawFilter;
@class ELSineFilter;
@class ELListFilter;
@class ELRandomFilter;

@interface ELFilterDesignerController : NSWindowController {
  IBOutlet NSTabView  *tabView;

  ELRangedKnob        *knob;
  ELSquareFilter      *squareFilter;
  ELSawFilter         *sawFilter;
  ELSineFilter        *sineFilter;
  ELListFilter        *listFilter;
  ELRandomFilter      *randomFilter;
  
  NSString            *selectedTag;
}

- (id)initWithKnob:(ELRangedKnob *)knob;

@property (readonly) ELRangedKnob *knob;

@property (readonly) ELSquareFilter *squareFilter;
@property (readonly) ELSawFilter *sawFilter;
@property (readonly) ELSineFilter *sineFilter;
@property (readonly) ELListFilter *listFilter;
@property (readonly) ELRandomFilter *randomFilter;

- (void)setView:(NSView *)view cellsAllowFloats:(BOOL)allowFloat;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
