//
//  ELHexInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELHexInspectorController.h"

#import "ELHex.h"
#import "ELTool.h"

#import "ELOscillatorDesignerController.h"

#import "RubyBlock.h"

@implementation ELHexInspectorController

@synthesize hex;

- (id)init {
  return [super initWithWindowNibName:@"HexInspector"];
}

- (void)awakeFromNib {
  [stackedList addSubview:generateBox];
  [stackedList addSubview:noteBox];
  [stackedList addSubview:reboundBox];
  [stackedList addSubview:absorbBox];
  [stackedList addSubview:splitBox];
  [stackedList addSubview:spinBox];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(selectionChanged:)
                                               name:ELNotifyObjectSelectionDidChange
                                             object:nil];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)_event_ {
  return YES;
}

- (void)focus:(ELHex *)_hex_ {
  [self setHex:_hex_];
  [stackedList rearrangeSubviews];
}

- (void)selectionChanged:(NSNotification*)_notification_
{
  if( [[_notification_ object] isKindOfClass:[ELHex class]] ) {
    [self focus:[_notification_ object]];
  }
}

- (void)editWillRunScript:(ELTool *)_tool_ {
  [[_tool_ script:@"willRun"] inspect:self];
}

- (IBAction)editOscillator:(id)_sender_ {
  [[[ELOscillatorDesignerController alloc] initWithKnob:_sender_] showWindow:self];
}

- (void)editDidRunScript:(ELTool *)_tool_ {
  [[_tool_ script:@"didRun"] inspect:self];
}

- (void)removeWillRunScript:(ELTool *)_tool_ {
  [_tool_ removeScript:@"willRun"];
}

- (void)removeDidRunScript:(ELTool *)_tool_ {
  [_tool_ removeScript:@"didRun"];
}

@end
