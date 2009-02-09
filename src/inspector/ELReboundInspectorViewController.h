//
//  ELReboundInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class LMDialView;

@interface ELReboundInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  NSSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  NSSegmentedControl  *gateModeControl;
  IBOutlet  LMDialView          *gateControl;
  IBOutlet  NSButton            *gateOscControl;
  
  IBOutlet  NSSegmentedControl  *directionModeControl;
  IBOutlet  NSSlider            *directionControl;
  IBOutlet  NSButton            *directionOscControl;
}

@end
