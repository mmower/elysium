//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELConfig;

extern NSString* const ELNotifyObjectSelectionDidChange;

@interface ELInspectorController : NSWindowController {
  IBOutlet NSPanel      *inspectorPanel;
  IBOutlet NSTabView    *tabView;
  
  // Hex inspector outlets
  
  IBOutlet NSTextField  *hexColumn;
  IBOutlet NSTextField  *hexRow;
  IBOutlet NSTextField  *hexNote;
  
  IBOutlet NSButton     *hexStartEnabled;
  IBOutlet NSSlider     *hexStartDirection;
  IBOutlet NSTextField  *hexStartTTL;
  
  IBOutlet NSButton     *hexBeatEnabled;
  IBOutlet NSTextField  *hexBeatVelocity;
  IBOutlet NSTextField  *hexBeatDuration;
  
  IBOutlet NSButton     *hexRicochetEnabled;
  IBOutlet NSSlider     *hexRicochetDirection;
  
  IBOutlet NSButton     *hexSplitterEnabled;
  IBOutlet NSButton     *hexSinkEnabled;
  IBOutlet NSButton     *hexRotorEnabled;
  
  id                    focusedObject;
}

- (void)selectionChanged:(NSNotification*)notification;

- (void)inspectHex;
- (void)inspectLayer;

- (ELHex *)focusedHex;

- (void)setIntField:(NSTextField *)input config:(ELConfig *)config key:(NSString *)key;
- (void)setFloatField:(NSTextField *)input config:(ELConfig *)config key:(NSString *)key;

- (IBAction)changedHexStartEnabled:(id)sender;
- (IBAction)changedHexStartDirection:(id)sender;
- (IBAction)changedHexStartTTL:(id)sender;
- (IBAction)resetHexStartTTL:(id)sender;

- (IBAction)changedHexBeatEnabled:(id)sender;
- (IBAction)changedHexBeatVelocity:(id)sender;
- (IBAction)resetHexBeatVelocity:(id)sender;
- (IBAction)changedHexBeatDuration:(id)sender;
- (IBAction)resetHexBeatDuration:(id)sender;

- (IBAction)changedHexRicochetEnabled:(id)sender;
- (IBAction)changedHexRicochetDirection:(id)sender;

- (IBAction)changedHexSplitterEnabled:(id)sender;
- (IBAction)changedHexSinkEnabled:(id)sender;
- (IBAction)changedHexRotorEnabled:(id)sender;

@end
