//
//  ELOscillatorDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

@property (assign) ELSquareOscillator *squareOscillator;
@property (assign) ELSawOscillator *sawOscillator;
@property (assign) ELSineOscillator *sineOscillator;
@property (assign) ELSequenceOscillator *sequenceOscillator;
@property (assign) ELRandomOscillator *randomOscillator;

- (void)setView:(NSView *)view cellsAllowFloats:(BOOL)allowFloat;

- (IBAction)saveOscillator:(id)sender;
- (IBAction)cancelOscillator:(id)sender;
- (IBAction)removeOscillator:(id)sender;

- (void)setupOscillators;
- (void)edit;

@end
