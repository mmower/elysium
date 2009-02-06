//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 02/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELPlayer;
@class ELLayer;
@class ELHex;

@interface ELInspectorController : NSWindowController {
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
  
  IBOutlet NSObjectController   *playerController;
  IBOutlet NSObjectController   *layerController;
  IBOutlet NSObjectController   *cellController;
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

@end
