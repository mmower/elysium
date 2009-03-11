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

@class ELCompositionManager;
@class ELInspectorController;
@class ELOscillatorDesignerController;
@class ELScriptPackageController;

@interface ElysiumDocument : NSDocument
{
  ELPlayer                        *player;
  
  NSString                        *composerName;
  NSString                        *composerEmail;
  
  NSString                        *title;
  NSString                        *notes;
  
  ELCompositionManager            *compositionManager;
  ELInspectorController           *inspectorController;
  ELOscillatorDesignerController  *oscillatorDesignerController;
  ELScriptPackageController       *scriptPackageController;
  
}

@property (readonly)  ELPlayer  *player;
@property (assign)    NSString  *composerName;
@property (assign)    NSString  *composerEmail;
@property (assign)    NSString  *title;
@property (assign)    NSString  *notes;

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
- (IBAction)toggleSkipToken:(id)sender;
- (IBAction)clearCell:(id)sender;

- (IBAction)showCompositionManager:(id)sender;
- (IBAction)showInspectorPanel:(id)sender;
- (IBAction)showOscillatorDesigner:(id)sender;
- (IBAction)showScriptPackageInspector:(id)sender;

@end
