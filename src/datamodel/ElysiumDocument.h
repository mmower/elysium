//
//  ElysiumDocument.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

- (void)updateView:(id)sender;

// Actions

- (IBAction)startStop:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)newLayer:(id)sender;
- (IBAction)clearSelectedLayer:(id)sender;
- (IBAction)closeDocument:(id)sender;
- (IBAction)toggleNoteDisplay:(id)sender;
- (IBAction)toggleKeyDisplay:(id)sender;
- (IBAction)toggleOctavesDisplay:(id)sender;

- (IBAction)toggleGeneratorToken:(id)sender;
- (IBAction)toggleNoteToken:(id)sender;
- (IBAction)toggleReboundToken:(id)sender;
- (IBAction)toggleAbsorbToken:(id)sender;
- (IBAction)toggleSplitToken:(id)sender;
- (IBAction)toggleSpinToken:(id)sender;
- (IBAction)clearCell:(id)sender;

@end
