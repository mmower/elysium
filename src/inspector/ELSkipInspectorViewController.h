//
//  ELSkipInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 23/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class ELSegmentedControl;
@class LMDialView;

@interface ELSkipInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  IBOutlet  ELSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;

  IBOutlet  ELSegmentedControl  *gateModeControl;
  IBOutlet  LMDialView          *gateControl;
  IBOutlet  NSButton            *gateOscControl;
  
  IBOutlet  ELSegmentedControl  *skipCountModeControl;
  IBOutlet  LMDialView          *skipCountControl;
  IBOutlet  NSButton            *skipCountOscControl;
  
  IBOutlet  NSButton            *editWillRunControl;
  IBOutlet  NSButton            *removeWillRunControl;
  IBOutlet  NSButton            *editDidRunControl;
  IBOutlet  NSButton            *removeDidRunControl;
}

@end
