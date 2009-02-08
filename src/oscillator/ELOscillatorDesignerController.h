//
//  ELOscillatorDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELDial;
@class ELSquareOscillator;
@class ELSawOscillator;
@class ELSineOscillator;
@class ELSequenceOscillator;
@class ELRandomOscillator;
@class ELInspectorController;

@interface ELOscillatorDesignerController : NSWindowController {
  ELInspectorController *controller;
  IBOutlet NSTabView    *tabView;

  ELDial                *dial;
  ELSquareOscillator    *squareOscillator;
  ELSawOscillator       *sawOscillator;
  ELSineOscillator      *sineOscillator;
  ELSequenceOscillator  *sequenceOscillator;
  ELRandomOscillator    *randomOscillator;
  
  NSString              *selectedTag;
}

- (id)initWithDial:(ELDial *)dial controller:(ELInspectorController *)controller;

@property             ELInspectorController *controller;
@property             ELDial *dial;

@property (assign)    ELSquareOscillator *squareOscillator;
@property (assign)    ELSawOscillator *sawOscillator;
@property (assign)    ELSineOscillator *sineOscillator;
@property (assign)    ELSequenceOscillator *sequenceOscillator;
@property (assign)    ELRandomOscillator *randomOscillator;

- (void)setView:(NSView *)view cellsAllowFloats:(BOOL)allowFloat;

- (IBAction)saveOscillator:(id)sender;
- (IBAction)cancelOscillator:(id)sender;
- (IBAction)removeOscillator:(id)sender;

- (void)setupOscillators;
- (void)edit;

@end
