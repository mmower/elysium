//
//  ELHexBeatInspectorPane.h
//  Elysium
//
//  Created by Matt Mower on 30/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorPane.h"

@interface ELHexBeatInspectorPane : ELInspectorPane {
  IBOutlet NSButton     *enabledButton;
  IBOutlet NSTextField  *velocityField;
  IBOutlet NSTextField  *durationField;
}

@end
