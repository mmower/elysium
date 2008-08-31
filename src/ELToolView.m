//
//  ELToolView.m
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELToolView.h"

NSString *ToolPBoardType = @"ToolPBoardType";

@implementation ELToolView

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)_isLocal_ {
  if( _isLocal_ ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (BOOL)acceptsFirstMouse:(NSEvent *)_event_ {
  return YES;
}

- (void)mouseDown:(NSEvent *)_event_ {
  savedEvent = _event_;
}

- (void)mouseDragged:(NSEvent *)_event_ {
  NSPoint down = [savedEvent locationInWindow];
  NSPoint drag = [_event_ locationInWindow];
  
  float distance = hypot( down.x - drag.x, down.y - drag.y );
  if( distance < 3 ) {
    return;
  }
  
  NSPoint p = [self convertPoint:down fromView:nil];
  
  p.x = p.x - [[self image] size].width / 2;
  p.y = p.y - [[self image] size].height / 2;
  
  NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  
  [pasteboard declareTypes:[NSArray arrayWithObject:ToolPBoardType] owner:self];
  [pasteboard setString:[[NSNumber numberWithInt:[self tag]] stringValue] forType:ToolPBoardType];
  
  [self dragImage:[self image]
               at:p
           offset:NSMakeSize(0,0)
            event:savedEvent
       pasteboard:pasteboard
           source:self
        slideBack:YES];
}

@end
