//
//  ElysiumController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@class ELMIDIConfigController;
@class ELPreferencesController;

@interface ElysiumController : NSObject {
  ELMIDIConfigController          *midiConfigController;
  ELPreferencesController         *preferencesController;
}

- (BOOL)initScriptingEngine;

- (ELPlayer *)activePlayer;

- (IBAction)showMIDIConfigInspector:(id)sender;
- (IBAction)showPreferences:(id)sender;

- (IBAction)showHelp:(id)sender;
- (IBAction)visitSupportPage:(id)sender;
- (IBAction)visitHomePage:(id)sender;
- (IBAction)visitTwitterPage:(id)sender;


@end
