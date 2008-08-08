//
//  ELInspectorController.h
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

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
  
  id                    focusedObject;
}

- (void)selectionChanged:(NSNotification*)notification;

- (void)inspectHex;
- (void)inspectLayer;

- (IBAction)changedHexStartEnabled:(id)sender;

@end
