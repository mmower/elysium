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
@class ELSegmentedControl;

@interface ELPlayerInspectorViewController : ELInspectorViewController {
            ELPlayer            *player;
            
  IBOutlet  ELSegmentedControl  *transposeModeControl;
  IBOutlet  LMDialView          *transposeControl;
  IBOutlet  NSButton            *transposeOscControl;
  
  IBOutlet  ELSegmentedControl  *tempoModeControl;
  IBOutlet  LMDialView          *tempoControl;
  IBOutlet  NSButton            *tempoOscControl;
  
  IBOutlet  ELSegmentedControl  *barLengthModeControl;
  IBOutlet  LMDialView          *barLengthControl;
  IBOutlet  NSButton            *barLengthOscControl;
  
  IBOutlet  ELSegmentedControl  *velocityModeControl;
  IBOutlet  LMDialView          *velocityControl;
  IBOutlet  NSButton            *velocityOscControl;
  
  IBOutlet  ELSegmentedControl  *emphasisModeControl;
  IBOutlet  LMDialView          *emphasisControl;
  IBOutlet  NSButton            *emphasisOscControl;
  
  IBOutlet  NSButton            *tempoSyncControl;
  
  IBOutlet  ELSegmentedControl  *noteLengthModeControl;
  IBOutlet  LMDialView          *noteLengthControl;
  IBOutlet  NSButton            *noteLengthOscControl;
  
  IBOutlet  ELSegmentedControl  *timeToLiveModeControl;
  IBOutlet  LMDialView          *timeToLiveControl;
  IBOutlet  NSButton            *timeToLiveOscControl;
  
  IBOutlet  ELSegmentedControl  *pulseEveryModeControl;
  IBOutlet  LMDialView          *pulseEveryControl;
  IBOutlet  NSButton            *pulseEveryOscControl;
}

- (id)initWithInspectorController:(ELInspectorController *)controller;

@end
