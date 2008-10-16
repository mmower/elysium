//
//  ELLayerInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELLayerInspectorController.h"

#import "ELHex.h"
#import "ELKey.h"
#import "ELLayer.h"

#import "RubyBlock.h"

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
  } else if( [[_notification_ object] isKindOfClass:[ELHex class]] ) {
    [self focus:(ELLayer *)[[_notification_ object] layer]];
  }
}

- (IBAction)editScript:(id)sender {
  RubyBlock *block;
  NSString *callback = @"unknown";
  
  switch( [sender tag] ) {
    case 0:
      callback = @"willRun";
      break;
    case 1:
      callback = @"didRun";
      break;
  }
  
  if( !( block = [[layer scripts] objectForKey:callback] ) ) {
    block = [@"do |layer|\n# write your callback code here\nend\n" asRubyBlock];
    [[layer scripts] setObject:block forKey:callback];
  }
  
  [block inspect];
}

- (IBAction)removeScript:(id)sender {
  NSString *callback = @"unknown";
  
  switch( [sender tag] ) {
    case 0:
      callback = @"willRun";
      break;
    case 1:
      callback = @"didRun";
      break;
  }
  
  [[layer scripts] removeObjectForKey:callback];
}

- (NSArray *)allKeys {
  return [ELKey allKeys];
}


@end
