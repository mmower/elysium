//
//  ELInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

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
}

- (void)windowDidLoad {
  NSLog( @"Nib file is loaded" );
}

@end
