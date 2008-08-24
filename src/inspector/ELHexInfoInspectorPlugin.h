//
//  ELHexinfoInspectorPlugin.h
//  Elysium
//
//  Created by Matt Mower on 10/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELInspectorPane.h"

@interface ELHexInfoInspectorPlugin : ELInspectorPane {
  IBOutlet NSTextField  *columnField;
  IBOutlet NSTextField  *rowField;
  IBOutlet NSTextField  *noteField;
}

@end
