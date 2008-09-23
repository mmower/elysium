//
//  ElysiumController.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELMIDIController;
@class ELPaletteController;

@class ELHexInspectorController;
@class ELLayerInspectorController;
@class ELPlayerInspectorController;
@class ELFilterDesignerController;

@interface ElysiumController : NSObject {
  ELHexInspectorController    *hexInspectorController;
  ELLayerInspectorController  *layerInspectorController;
  ELPlayerInspectorController *playerInspectorController;
  ELFilterDesignerController  *filterDesignerController;
  
  ELMIDIController            *midiController;
  ELPaletteController         *paletteController;
}

- (IBAction)showPalette:(id)sender;

- (IBAction)showFilterDesigner:(id)sender;
- (IBAction)showHexInspector:(id)sender;
- (IBAction)showLayerInspector:(id)sender;
- (IBAction)showPlayerInspector:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;

- (ELMIDIController *)midiController;

@end
