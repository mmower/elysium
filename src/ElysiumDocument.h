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

@interface ElysiumDocument : NSDocument
{
  IBOutlet  NSButton      *controlButton;
  ELPlayer                *player;
  IBOutlet  ELLayerView   *layerView;
}

- (ElysiumController *)appController;
- (ELMIDIController *)midiController;

- (IBAction)startStop:(id)sender;

@end
