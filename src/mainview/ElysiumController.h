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

@class ELCompositionManager;
@class ELInspectorController;
@class ELLayerManagerWindowController;
@class ELScriptPackageController;

@interface ElysiumController : NSObject {
  ELMIDIConfigController          *midiConfigController;
  ELPreferencesController         *preferencesController;
  
  ELCompositionManager            *compositionManager;
  ELInspectorController           *inspectorController;
  ELLayerManagerWindowController  *layerManager;
  ELScriptPackageController       *scriptPackageController;
}

- (BOOL)initScriptingEngine;

- (ELPlayer *)activePlayer;

- (IBAction)showMIDIConfigInspector:(id)sender;
- (IBAction)showPreferences:(id)sender;

- (IBAction)showHelp:(id)sender;
- (IBAction)visitSupportPage:(id)sender;
- (IBAction)visitHomePage:(id)sender;
- (IBAction)visitTwitterPage:(id)sender;

- (IBAction)showCompositionManager:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;
- (IBAction)showLayerManager:(id)sender;
- (IBAction)showScriptPackageInspector:(id)sender;

@end
