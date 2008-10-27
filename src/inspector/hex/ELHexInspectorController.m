//
//  ELHexInspectorController.m
//  Elysium
//
//  Created by Matt Mower on 22/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
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
  RubyBlock *block;
  
  if( !( block = [[_tool_ scripts] objectForKey:@"willRun"] ) ) {
    block = [[NSString stringWithFormat:@"do |%@Tool,playhead|\n\t# write your callback code here\nend\n", [_tool_ toolType]] asRubyBlock];
    [[_tool_ scripts] setObject:block forKey:@"willRun"];
  }
  
  [block inspect:self];
}

- (IBAction)editOscillator:(id)_sender_ {
  [[[ELOscillatorDesignerController alloc] initWithKnob:_sender_] showWindow:self];
}

- (void)editDidRunScript:(ELTool *)_tool_ {
  RubyBlock *block;
  
  if( !( block = [[_tool_ scripts] objectForKey:@"didRun"] ) ) {
    block = [[NSString stringWithFormat:@"do |@%Tool,playhead|\n\t# write your callback code here\nend\n", [_tool_ toolType]] asRubyBlock];
    [[_tool_ scripts] setObject:block forKey:@"didRun"];
  }
  
  [block inspect:self];
}

- (void)removeWillRunScript:(ELTool *)_tool_ {
  [[_tool_ scripts] removeObjectForKey:@"willRun"];
}

- (void)removeDidRunScript:(ELTool *)_tool_ {
  [[_tool_ scripts] removeObjectForKey:@"didRun"];
}

@end
