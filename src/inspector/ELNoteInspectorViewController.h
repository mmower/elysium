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

@interface ELNoteInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  NSSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  NSSegmentedControl  *gateModeControl;
  IBOutlet  LMDialView          *gateControl;
  IBOutlet  NSButton            *gateOscControl;
  
  IBOutlet  NSSegmentedControl  *velocityModeControl;
  IBOutlet  LMDialView          *velocityControl;
  IBOutlet  NSButton            *velocityOscControl;
  
  IBOutlet  NSSegmentedControl  *emphasisModeControl;
  IBOutlet  LMDialView          *emphasisControl;
  IBOutlet  NSButton            *emphasisOscControl;
  
  IBOutlet  NSSegmentedControl  *tempoSyncModeControl;
  IBOutlet  NSButton            *tempoSyncControl;
  IBOutlet  NSButton            *tempoSyncOscControl;
  
  IBOutlet  NSSegmentedControl  *noteLengthModeControl;
  IBOutlet  LMDialView          *noteLengthControl;
  IBOutlet  NSButton            *noteLengthOscControl;
  
  IBOutlet  NSSegmentedControl  *ghostsModeControl;
  IBOutlet  LMDialView          *ghostsControl;
  IBOutlet  NSButton            *ghostsOscControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
