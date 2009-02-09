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

@interface ELGenerateInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  NSSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  NSSegmentedControl  *directionModeControl;
  IBOutlet  NSSlider            *directionControl;
  IBOutlet  NSButton            *directionOscControl;
  
  IBOutlet  NSSegmentedControl  *timeToLiveModeControl;
  IBOutlet  LMDialView          *timeToLiveControl;
  IBOutlet  NSButton            *timeToLiveOscControl;
  
  IBOutlet  NSSegmentedControl  *pulseEveryModeControl;
  IBOutlet  LMDialView          *pulseEveryControl;
  IBOutlet  NSButton            *pulseEveryOscControl;
  
  IBOutlet  NSSegmentedControl  *offsetModeControl;
  IBOutlet  LMDialView          *offsetControl;
  IBOutlet  NSButton            *offsetOscControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
