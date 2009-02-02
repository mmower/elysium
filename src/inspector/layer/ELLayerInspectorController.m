//
//  ELLayerInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELLayerInspectorController.h"

#import "ELHex.h"
#import "ELKey.h"
#import "ELLayer.h"

#import "ELOscillatorDesignerController.h"

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

- (IBAction)editOscillator:(id)_sender_ {
  [[[ELOscillatorDesignerController alloc] initWithDial:_sender_] showWindow:self];
}

- (IBAction)editScript:(id)sender {
  ELScript *block;
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
    block = [@"function(player,layer) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
    [[layer scripts] setObject:block forKey:callback];
  }
  
  [block inspect:self];
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
