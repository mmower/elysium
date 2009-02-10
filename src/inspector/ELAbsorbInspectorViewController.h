//
//  ELAbsorbInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class LMDialView;
@class ELSegmentedControl;

@interface ELAbsorbInspectorViewController : ELInspectorViewController {
  IBOutlet  NSButton            *enabledControl;
  
  IBOutlet  ELSegmentedControl  *pModeControl;
  IBOutlet  LMDialView          *pControl;
  IBOutlet  NSButton            *pOscControl;
  
  IBOutlet  ELSegmentedControl  *gateModeControl;
  IBOutlet  LMDialView          *gateControl;
  IBOutlet  NSButton            *gateOscControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
