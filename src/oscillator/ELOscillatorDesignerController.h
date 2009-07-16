//
//  ELOscillatorDesignerController.h
//  Elysium
//
//  Created by Matt Mower on 23/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class LMDialView;

@class ELDial;
@class ELSquareOscillator;
@class ELSawOscillator;
@class ELSineOscillator;
@class ELRampOscillator;
@class ELSequenceOscillator;
@class ELRandomOscillator;
@class ELInspectorController;

@interface ELOscillatorDesignerController : NSWindowController {
  ELInspectorController *_controller;
  IBOutlet NSTabView    *tabView;

  ELDial                *_dial;
  ELSquareOscillator    *_squareOscillator;
  ELSawOscillator       *_sawOscillator;
  ELSineOscillator      *_sineOscillator;
  ELRampOscillator      *_rampOscillator;
  ELSequenceOscillator  *_sequenceOscillator;
  ELRandomOscillator    *_randomOscillator;
  
  IBOutlet  LMDialView  *squareLFOMinDial;
  IBOutlet  LMDialView  *squareLFOMaxDial;
  IBOutlet  LMDialView  *squareLFORestDial;
  IBOutlet  LMDialView  *squareLFOSustainDial;
  
  IBOutlet  LMDialView  *sawLFOMinDial;
  IBOutlet  LMDialView  *sawLFOMaxDial;
  IBOutlet  LMDialView  *sawLFOAttackDial;
  IBOutlet  LMDialView  *sawLFOSustainDial;
  IBOutlet  LMDialView  *sawLFODecayDial;
  IBOutlet  LMDialView  *sawLFORestDial;
  
  IBOutlet  LMDialView  *sineLFOMinDial;
  IBOutlet  LMDialView  *sineLFOMaxDial;
  IBOutlet  LMDialView  *sineLFOPeriodDial;
  
  IBOutlet  LMDialView  *rampLFOMinDial;
  IBOutlet  LMDialView  *rampLFOMaxDial;
  IBOutlet  LMDialView  *rampLFOPeriodDial;
  IBOutlet  NSButton    *rampLFORisingButton;
  
  IBOutlet  LMDialView  *randomLFOMinDial;
  IBOutlet  LMDialView  *randomLFOMaxDial;
  
  NSString              *selectedTag;
}

- (id)initWithDial:(ELDial *)dial controller:(ELInspectorController *)controller;

@property             ELInspectorController *controller;

@property (assign)    ELSquareOscillator    *squareOscillator;
@property (assign)    ELSawOscillator       *sawOscillator;
@property (assign)    ELSineOscillator      *sineOscillator;
@property (assign)    ELRampOscillator      *rampOscillator;
@property (assign)    ELSequenceOscillator  *sequenceOscillator;
@property (assign)    ELRandomOscillator    *randomOscillator;

- (IBAction)saveOscillator:(id)sender;
- (IBAction)cancelOscillator:(id)sender;
- (IBAction)removeOscillator:(id)sender;

- (void)setupOscillators;
- (void)edit;

@end
