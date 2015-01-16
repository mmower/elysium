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

@class ELOscillatorDesignerController;

@interface ElysiumDocument : NSDocument
{
  ELPlayer                        *_player;
  
  NSString                        *_composerName;
  NSString                        *_composerEmail;
  
  NSString                        *_title;
  NSString                        *_notes;
  
  ELOscillatorDesignerController  *_oscillatorDesignerController;
}

@property (nonatomic,readonly)  ELPlayer  *player;
@property  (nonatomic,assign)     NSString  *composerName;
@property  (nonatomic,assign)     NSString  *composerEmail;
@property  (nonatomic,assign)     NSString  *title;
@property  (nonatomic,assign)     NSString  *notes;

- (ElysiumController *)appController;

- (void)updateView:(id)sender;

// Actions

- (IBAction)startStop:(id)sender;
- (IBAction)clearAll:(id)sender;
- (IBAction)newLayer:(id)sender;
- (IBAction)removeLayer:(id)sender;
- (IBAction)clearSelectedLayer:(id)sender;
- (IBAction)closeDocument:(id)sender;

- (IBAction)toggleGeneratorToken:(id)sender;
- (IBAction)toggleNoteToken:(id)sender;
- (IBAction)toggleReboundToken:(id)sender;
- (IBAction)toggleAbsorbToken:(id)sender;
- (IBAction)toggleSplitToken:(id)sender;
- (IBAction)toggleSpinToken:(id)sender;
- (IBAction)toggleSkipToken:(id)sender;
- (IBAction)clearCell:(id)sender;

- (IBAction)showOscillatorDesigner:(id)sender;

- (void)documentNewLayer:(ELLayer *)layer;
- (void)documentRemoveLayer:(ELLayer *)layer;

@end
