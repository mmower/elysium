//
//  ElysiumController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELMIDIController;
@class ELInspectorController;

@interface ElysiumController : NSObject {
  ELMIDIController        *midiController;
  ELInspectorController   *inspectorController;
}

- (IBAction)showInspectorPanel:(id)sender;

- (ELMIDIController *)midiController;

@end
