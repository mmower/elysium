//
//  ELHexInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHexInspectorController.h"

#import "ELHex.h"

@implementation ELHexInspectorController

@synthesize hex;

- (id)init {
  return [super initWithWindowNibName:@"HexInspector"];
}

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)focus:(ELHex *)_hex_ {
  
  [self setHex:_hex_];
}

- (void)selectionChanged:(NSNotification*)_notification_
{
  if( [[_notification_ object] isKindOfClass:[ELHex class]] ) {
    [self focus:[_notification_ object]];
  }
}

@end
