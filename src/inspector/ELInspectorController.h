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
@class ELHex;

@class ELInspectorViewController;

@interface ELInspectorController : NSWindowController {
  IBOutlet  NSPanel             *panel;
  IBOutlet  NSSegmentedControl  *modeView;
  IBOutlet  NSTabView           *tabView;
  
  IBOutlet  NSView              *playerView;
  IBOutlet  NSView              *layerView;
  IBOutlet  NSView              *generatorView;
  IBOutlet  NSView              *noteView;
  IBOutlet  NSView              *reboundView;
  IBOutlet  NSView              *absorbView;
  IBOutlet  NSView              *splitView;
  IBOutlet  NSView              *spinView;
  
            ELPlayer            *player;
            ELLayer             *layer;
            ELHex               *cell;
            
            NSString            *title;
  
            ELInspectorViewController *playerViewController;
            ELInspectorViewController *layerViewController;
            ELInspectorViewController *generateViewController;
            ELInspectorViewController *noteViewController;
            ELInspectorViewController *reboundViewController;
            ELInspectorViewController *absorbViewController;
            ELInspectorViewController *splitViewController;
            ELInspectorViewController *spinViewController;
  
            NSMutableDictionary *oscillatorEditors;
}

@property           NSSegmentedControl  *modeView;
@property           NSTabView           *tabView;

@property           ELPlayer            *player;
@property           ELLayer             *layer;
@property           ELHex               *cell;

@property (assign)  NSString            *title;

- (IBAction)selectTab:(id)sender;

- (void)selectionChanged:(NSNotification *)notification;
- (void)playerSelected:(ELPlayer *)player;
- (void)layerSelected:(ELLayer *)layer;
- (void)cellSelected:(ELHex *)cell;

- (NSArray *)keySignatures;

- (IBAction)editOscillator:(ELDial *)dial;
- (void)finishedEditingOscillatorForDial:(ELDial *)dial;

- (void)editCallback:(id)scriptable tag:(NSNumber *)tag;
- (void)removeCallback:(id)scriptable tag:(NSNumber *)tag;

@end
