//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELDial;
@class ELPlayer;
@class ELLayer;
@class ELCell;

@class ELInspectorViewController;

@interface ELInspectorController : NSWindowController {
  IBOutlet  NSPanel             *_panel;
  IBOutlet  NSSegmentedControl  *_modeView;
  IBOutlet  NSTabView           *_tabView;
  
  IBOutlet  NSView              *playerView;
  IBOutlet  NSView              *layerView;
  IBOutlet  NSView              *generatorView;
  IBOutlet  NSView              *noteView;
  IBOutlet  NSView              *reboundView;
  IBOutlet  NSView              *absorbView;
  IBOutlet  NSView              *splitView;
  IBOutlet  NSView              *spinView;
  
            ELPlayer            *_player;
            ELLayer             *_layer;
            ELCell              *_cell;
            
            NSString            *title;
  
            ELInspectorViewController *playerViewController;
            ELInspectorViewController *layerViewController;
            ELInspectorViewController *generateViewController;
            ELInspectorViewController *noteViewController;
            ELInspectorViewController *reboundViewController;
            ELInspectorViewController *absorbViewController;
            ELInspectorViewController *splitViewController;
            ELInspectorViewController *spinViewController;
            ELInspectorViewController *skipViewController;
            
            NSMapTable          *oscillatorEditors;
}

@property           NSPanel             *panel;
@property           NSSegmentedControl  *modeView;
@property           NSTabView           *tabView;

@property           ELPlayer            *player;
@property           ELLayer             *layer;
@property           ELCell              *cell;

@property (assign)  NSString            *title;

- (IBAction)selectTab:(id)sender;

- (void)inspect:(NSString *)identifier;

- (void)selectionChanged:(NSNotification *)notification;
- (void)playerSelected:(ELPlayer *)player;
- (void)layerSelected:(ELLayer *)layer;
- (void)cellSelected:(ELCell *)cell;

- (NSArray *)keySignatures;

- (IBAction)editOscillator:(ELDial *)dial;
- (void)finishedEditingOscillatorForDial:(ELDial *)dial;

- (void)editCallback:(id)scriptable tag:(NSNumber *)tag;
- (void)removeCallback:(id)scriptable tag:(NSNumber *)tag;

@end
