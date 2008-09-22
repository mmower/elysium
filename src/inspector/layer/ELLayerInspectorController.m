//
//  ELLayerInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELLayerInspectorController.h"

@implementation ELLayerInspectorController

@synthesize layer;

- (id)init {
  return [super initWithWindowNibName:@"LayerInspector"];
}

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (void)focus:(ELLayer *)_layer_ {
  [self setLayer:_layer_];
}

- (void)selectionChanged:(NSNotification*)_notification_
{
  if( [[_notification_ object] isKindOfClass:[ELLayer class]] ) {
    [self focus:[_notification_ object]];
  }
}

@end
