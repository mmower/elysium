//
//  ELPlayerInspectorPane.h
//  Elysium
//
//  Created by Matt Mower on 03/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorPane.h"

@class ELPlayer;

@interface ELPlayerInspectorPane : ELInspectorPane {
  IBOutlet NSTextField    *tempoField;
}

@end
