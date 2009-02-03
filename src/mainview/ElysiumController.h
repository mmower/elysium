//
//  ElysiumController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELInspectorController;
@class ELOscillatorDesignerController;
@class ELMIDIConfigController;
@class ELScriptPackageController;
@class ELPreferencesController;

@class ELPlayer;

@interface ElysiumController : NSObject {
  ELInspectorController           *inspectorController;
  ELOscillatorDesignerController  *oscillatorDesignerController;
  ELMIDIConfigController          *midiConfigController;
  ELScriptPackageController       *scriptPackageController;
  ELPreferencesController         *preferencesController;
}

- (BOOL)initScriptingEngine;

- (ELPlayer *)activePlayer;

- (IBAction)showOscillatorDesigner:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;
- (IBAction)showMIDIConfigInspector:(id)sender;
- (IBAction)showScriptPackageInspector:(id)sender;
- (IBAction)showPreferences:(id)sender;
- (IBAction)satisfyMe:(id)sender;
- (IBAction)showHelp:(id)sender;

@end
