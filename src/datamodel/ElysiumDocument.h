//
//  ElysiumDocument.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

#import "ELPlayer.h"

@class ElysiumController;
@class ELSurfaceView;

@interface ElysiumDocument : NSDocument
{
  ELPlayer                    *player;
}

@property (readonly) ELPlayer *player;

- (ElysiumController *)appController;
- (ELMIDIController *)midiController;

- (void)updateView:(id)sender;

// Actions

- (IBAction)startStop:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)newLayer:(id)sender;
- (IBAction)closeDocument:(id)sender;
- (IBAction)notesOnOff:(id)sender;
- (IBAction)toggleKeyDisplay:(id)sender;
- (IBAction)toggleOctavesDisplay:(id)sender;

@end
