//
//  ElysiumDocument.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//


#import <Cocoa/Cocoa.h>

#import "ELPlayer.h"

@class ELLayerView;
@class ElysiumController;
@class LMHoneycombView;

@interface ElysiumDocument : NSDocument
{
  IBOutlet  NSButton          *controlButton;
  ELPlayer                    *player;
  IBOutlet  LMHoneycombView   *layerView;
}

- (ElysiumController *)appController;
- (ELMIDIController *)midiController;

- (void)updateView:(id)sender;

- (IBAction)startStop:(id)sender;

@end
