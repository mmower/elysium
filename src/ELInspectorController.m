//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELInspectorController.h"

@implementation ELInspectorController

- (id)init {
  if( self = [super initWithWindowNibName:@"Inspector"] ) {
  }
  return self;
}

- (void)awakeFromNib {
  [inspectorPanel setFloatingPanel:YES];
  [inspectorPanel setBecomesKeyOnlyIfNeeded:YES];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:notifyObjectSelectionDidChange
                                             object:nil];
}

- (void)finalize {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [super finalize];
}

- (void)windowDidLoad {
  NSLog( @"Nib file is loaded" );
}

- (void)windowWillClose {
  NSLog( @"window will close" );
}

- (void)selectionChanged:(NSNotification*)_notification
{
  NSLog( @"Inspector-%@ got selection notification: %@", self, _notification );
}

@end
