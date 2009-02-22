//
//  ELNoteInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class LMDialView;
@class ELSegmentedControl;

@interface ELNoteInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  ELSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  ELSegmentedControl  *gateModeControl;
  IBOutlet  LMDialView          *gateControl;
  IBOutlet  NSButton            *gateOscControl;
  
  IBOutlet  ELSegmentedControl  *velocityModeControl;
  IBOutlet  LMDialView          *velocityControl;
  IBOutlet  NSButton            *velocityOscControl;
  
  IBOutlet  ELSegmentedControl  *emphasisModeControl;
  IBOutlet  LMDialView          *emphasisControl;
  IBOutlet  NSButton            *emphasisOscControl;
  
  IBOutlet  ELSegmentedControl  *tempoSyncModeControl;
  IBOutlet  NSButton            *tempoSyncControl;
  IBOutlet  NSButton            *tempoSyncOscControl;
  
  IBOutlet  ELSegmentedControl  *noteLengthModeControl;
  IBOutlet  LMDialView          *noteLengthControl;
  IBOutlet  NSButton            *noteLengthOscControl;
  
  IBOutlet  ELSegmentedControl  *ghostsModeControl;
  IBOutlet  LMDialView          *ghostsControl;
  IBOutlet  NSButton            *ghostsOscControl;
  
  IBOutlet  NSSegmentedControl  *triadControl;
  
  IBOutlet  NSButton            *overrideControl;
  IBOutlet  ELSegmentedControl  *channelOverrideSelectControl;
  
  IBOutlet  NSButton            *editWillRunControl;
  IBOutlet  NSButton            *removeWillRunControl;
  IBOutlet  NSButton            *editDidRunControl;
  IBOutlet  NSButton            *removeDidRunControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

- (void)bindTriadControl;
- (void)bindOverrideControls;

@end
