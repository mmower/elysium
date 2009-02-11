//
//  ELGenerateInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class LMDialView;
@class ELSegmentedControl;

@interface ELGenerateInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  ELSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  ELSegmentedControl  *directionModeControl;
  IBOutlet  NSSlider            *directionControl;
  IBOutlet  NSButton            *directionOscControl;
  
  IBOutlet  ELSegmentedControl  *timeToLiveModeControl;
  IBOutlet  LMDialView          *timeToLiveControl;
  IBOutlet  NSButton            *timeToLiveOscControl;
  
  IBOutlet  ELSegmentedControl  *pulseEveryModeControl;
  IBOutlet  LMDialView          *pulseEveryControl;
  IBOutlet  NSButton            *pulseEveryOscControl;
  
  IBOutlet  ELSegmentedControl  *offsetModeControl;
  IBOutlet  LMDialView          *offsetControl;
  IBOutlet  NSButton            *offsetOscControl;
  
  IBOutlet  NSButton            *editWillRunControl;
  IBOutlet  NSButton            *removeWillRunControl;
  IBOutlet  NSButton            *editDidRunControl;
  IBOutlet  NSButton            *removeDidRunControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
