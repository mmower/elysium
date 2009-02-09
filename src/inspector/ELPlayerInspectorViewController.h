//
//  ELPlayerInspectorViewController.h
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorViewController.h"

@class ELPlayer;
@class LMDialView;

@interface ELPlayerInspectorViewController : ELInspectorViewController {
            ELPlayer            *player;
            
  IBOutlet  NSSegmentedControl  *transposeModeControl;
  IBOutlet  LMDialView          *transposeControl;
  IBOutlet  NSButton            *transposeOscControl;
  
  IBOutlet  NSSegmentedControl  *tempoModeControl;
  IBOutlet  LMDialView          *tempoControl;
  IBOutlet  NSButton            *tempoOscControl;
  
  IBOutlet  NSSegmentedControl  *barLengthModeControl;
  IBOutlet  LMDialView          *barLengthControl;
  IBOutlet  NSButton            *barLengthOscControl;
  
  IBOutlet  NSSegmentedControl  *velocityModeControl;
  IBOutlet  LMDialView          *velocityControl;
  IBOutlet  NSButton            *velocityOscControl;
  
  IBOutlet  NSSegmentedControl  *emphasisModeControl;
  IBOutlet  LMDialView          *emphasisControl;
  IBOutlet  NSButton            *emphasisOscControl;
  
  IBOutlet  NSButton            *tempoSyncControl;
  
  IBOutlet  NSSegmentedControl  *noteLengthModeControl;
  IBOutlet  LMDialView          *noteLengthControl;
  IBOutlet  NSButton            *noteLengthOscControl;
  
  IBOutlet  NSSegmentedControl  *timeToLiveModeControl;
  IBOutlet  LMDialView          *timeToLiveControl;
  IBOutlet  NSButton            *timeToLiveOscControl;
  
  IBOutlet  NSSegmentedControl  *pulseEveryModeControl;
  IBOutlet  LMDialView          *pulseEveryControl;
  IBOutlet  NSButton            *pulseEveryOscControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
