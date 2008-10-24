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

@interface ElysiumController : NSObject {
  ELHexInspectorController    *hexInspectorController;
  ELLayerInspectorController  *layerInspectorController;
  ELPlayerInspectorController *playerInspectorController;
  ELOscillatorDesignerController  *filterDesignerController;
  
  ELPaletteController         *paletteController;
  ELActivityViewerController  *activityViewerController;
}

- (IBAction)showFilterDesigner:(id)sender;
- (IBAction)showHexInspector:(id)sender;
- (IBAction)showLayerInspector:(id)sender;
- (IBAction)showPlayerInspector:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;

- (IBAction)showPalette:(id)sender;
- (IBAction)showActivityViewer:(id)sender;

- (void)recordActivity:(NSDictionary *)activity;

@end
