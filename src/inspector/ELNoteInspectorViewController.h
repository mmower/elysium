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
  IBOutlet  NSScrollView        *channelOverrideSelectorView;
  
  IBOutlet  ELSegmentedControl  *chan1OverrideModeControl;
  IBOutlet  LMDialView          *chan1OverrideControl;
  IBOutlet  NSButton            *chan1OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan2OverrideModeControl;
  IBOutlet  LMDialView          *chan2OverrideControl;
  IBOutlet  NSButton            *chan2OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan3OverrideModeControl;
  IBOutlet  LMDialView          *chan3OverrideControl;
  IBOutlet  NSButton            *chan3OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan4OverrideModeControl;
  IBOutlet  LMDialView          *chan4OverrideControl;
  IBOutlet  NSButton            *chan4OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan5OverrideModeControl;
  IBOutlet  LMDialView          *chan5OverrideControl;
  IBOutlet  NSButton            *chan5OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan6OverrideModeControl;
  IBOutlet  LMDialView          *chan6OverrideControl;
  IBOutlet  NSButton            *chan6OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan7OverrideModeControl;
  IBOutlet  LMDialView          *chan7OverrideControl;
  IBOutlet  NSButton            *chan7OverrideOscControl;
  
  IBOutlet  ELSegmentedControl  *chan8OverrideModeControl;
  IBOutlet  LMDialView          *chan8OverrideControl;
  IBOutlet  NSButton            *chan8OverrideOscControl;
  
  IBOutlet  NSButton            *editWillRunControl;
  IBOutlet  NSButton            *removeWillRunControl;
  IBOutlet  NSButton            *editDidRunControl;
  IBOutlet  NSButton            *removeDidRunControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

- (void)bindTriadControl;
- (void)bindOverrideControls;

@end
