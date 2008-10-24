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
@class ELSequenceOscillator;
@class ELRandomOscillator;

@interface ELOscillatorDesignerController : NSWindowController {
  IBOutlet NSTabView    *tabView;

  ELRangedKnob          *knob;
  ELSquareOscillator    *squareOscillator;
  ELSawOscillator       *sawOscillator;
  ELSineOscillator      *sineOscillator;
  ELSequenceOscillator  *sequenceOscillator;
  ELRandomOscillator    *randomOscillator;
  
  NSString              *selectedTag;
}

- (id)initWithKnob:(ELRangedKnob *)knob;

@property (readonly) ELRangedKnob *knob;

@property (readonly) ELSquareOscillator *squareOscillator;
@property (readonly) ELSawOscillator *sawOscillator;
@property (readonly) ELSineOscillator *sineOscillator;
@property (readonly) ELSequenceOscillator *sequenceOscillator;
@property (readonly) ELRandomOscillator *randomOscillator;

- (void)setView:(NSView *)view cellsAllowFloats:(BOOL)allowFloat;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
