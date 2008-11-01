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
@class ELOscillatorDesignerController;
@class ELActivityViewerController;
@class ELMIDIConfigController;

@interface ElysiumController : NSObject {
  ELHexInspectorController        *hexInspectorController;
  ELLayerInspectorController      *layerInspectorController;
  ELPlayerInspectorController     *playerInspectorController;
  ELOscillatorDesignerController  *oscillatorDesignerController;
  ELPaletteController             *paletteController;
  ELActivityViewerController      *activityViewerController;
  ELMIDIConfigController          *midiConfigController;
}

- (void)initMacRuby;

- (IBAction)showOscillatorDesigner:(id)sender;
- (IBAction)showHexInspector:(id)sender;
- (IBAction)showLayerInspector:(id)sender;
- (IBAction)showPlayerInspector:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;
- (IBAction)showMIDIConfigInspector:(id)sender;

- (IBAction)showPalette:(id)sender;
- (IBAction)showActivityViewer:(id)sender;
- (IBAction)satisfyMe:(id)sender;

- (void)recordActivity:(NSDictionary *)activity;

@end
