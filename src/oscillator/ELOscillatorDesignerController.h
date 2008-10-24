//
//  ELOscillatorDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELRangedKnob;
@class ELSquareOscillator;
@class ELSawOscillator;
@class ELSineOscillator;
@class ELListOscillator;
@class ELRandomOscillator;

@interface ELOscillatorDesignerController : NSWindowController {
  IBOutlet NSTabView  *tabView;

  ELRangedKnob        *knob;
  ELSquareOscillator      *squareFilter;
  ELSawOscillator         *sawFilter;
  ELSineOscillator        *sineFilter;
  ELListOscillator        *listFilter;
  ELRandomOscillator      *randomFilter;
  
  NSString            *selectedTag;
}

- (id)initWithKnob:(ELRangedKnob *)knob;

@property (readonly) ELRangedKnob *knob;

@property (readonly) ELSquareOscillator *squareFilter;
@property (readonly) ELSawOscillator *sawFilter;
@property (readonly) ELSineOscillator *sineFilter;
@property (readonly) ELListOscillator *listFilter;
@property (readonly) ELRandomOscillator *randomFilter;

- (void)setView:(NSView *)view cellsAllowFloats:(BOOL)allowFloat;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
