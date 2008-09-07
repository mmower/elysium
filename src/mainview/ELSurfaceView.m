//
//  ELSurfaceView.m
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSurfaceView.h"

#import "ELHex.h"
#import "ELToolView.h"

#import "ELBeatTool.h"
#import "ELSinkTool.h"
#import "ELRotorTool.h"
#import "ELStartTool.h"
#import "ELRicochetTool.h"
#import "ELSplitterTool.h"

NSString* const ELToolColor = @"tool.color";
NSString *HexPBoardType = @"HexPBoardType";

@implementation ELSurfaceView

- (id)initWithFrame:(NSRect)_frame_ {
  if( ( self = [super initWithFrame:_frame_] ) ) {
    [self setDefaultColor:[NSColor colorWithDeviceRed:(12.0/255) green:(153.0/255) blue:(206.0/255) alpha:0.8]];
    [self setBorderColor:[NSColor colorWithDeviceRed:(11.0/255) green:(75.0/255) blue:(169.0/255) alpha:0.8]];
    [self setSelectedColor:[NSColor blueColor]];
    [self setToolColor:[NSColor yellowColor]];
    [self registerForDraggedTypes:[NSArray arrayWithObjects:ToolPBoardType,HexPBoardType,nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellWasUpdated:)
                                                 name:ELNotifyCellWasUpdated
                                               object:nil];
  }
  
  return self;
}

@dynamic toolColor;

- (void)setToolColor:(NSColor *)_color_ {
  [[self drawingAttributes] setObject:_color_ forKey:ELToolColor];
}

- (NSColor *)toolColor {
  return [[self drawingAttributes] objectForKey:ELToolColor];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)_event_ {
  return YES;
}

// General view support

- (ELHex *)cellUnderMouseLocation:(NSPoint)_point_ {
  return (ELHex *)[self findCellAtPoint:[self convertPoint:_point_ fromView:nil]];
}

- (ELHex *)selectedHex {
  return (ELHex *)[self selected];
}

// Tool management

- (void)addTool:(int)_toolTag_ toCell:(ELHex *)_cell_ {
  switch( _toolTag_ ) {
    case EL_TOOL_GENERATOR:
      [_cell_ addTool:[[ELStartTool alloc] init]];
      break;
      
    case EL_TOOL_BEAT:
      [_cell_ addTool:[[ELBeatTool alloc] init]];
      break;
      
    case EL_TOOL_RICOCHET:
      [_cell_ addTool:[[ELRicochetTool alloc] init]];
      break;
      
    case EL_TOOL_SINK:
      [_cell_ addTool:[[ELSinkTool alloc] init]];
      break;
      
    case EL_TOOL_SPLITTER:
      [_cell_ addTool:[[ELSplitterTool alloc] init]];
      break;
      
    case EL_TOOL_ROTOR:
      [_cell_ addTool:[[ELRotorTool alloc] init]];
      break;
      
    case EL_TOOL_CLEAR:
      [_cell_ removeAllTools];
      break;
      
    default:
      NSAssert1( NO, @"Unknown tool tag %d experienced!", _toolTag_ );
  }
  
  [self setNeedsDisplay:YES];
}

- (void)dragFromHex:(ELHex *)_sourceHex_ to:(ELHex *)_targetHex_ with:(NSDragOperation)_modifiers_ {
  [_targetHex_ removeAllTools];
  
  for( ELTool *tool in [_sourceHex_ tools] ) {
    [_targetHex_ addTool:[tool mutableCopy]];
  }
  
  if( !_modifiers_ & NSDragOperationCopy ) {
    [_sourceHex_ removeAllTools];
  }
  
  [self setNeedsDisplay:YES];
}

// Hex-to-Hex drag support

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)_isLocal_ {
  if( _isLocal_ ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (void)mouseDown:(NSEvent *)_event_ {
  [super mouseDown:_event_];
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
  
  NSImage *image = [NSImage imageNamed:@"hexdrag"];
  
  p.x = p.x - [image size].width / 2;
  p.y = p.y - [image size].height / 2;
  
  NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
  [pasteboard declareTypes:[NSArray arrayWithObject:HexPBoardType] owner:self];
  
  [pasteboard setString:@"foo" forType:HexPBoardType]; // Dummy, we'll just work of [self selected] anyway
  
  [self dragImage:image
               at:p
           offset:NSMakeSize(0,0)
            event:savedEvent
       pasteboard:pasteboard
           source:self
        slideBack:YES];
}

// Drag & Drop tool adding support

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)_sender_ {
  ELHex *cell = [self cellUnderMouseLocation:[_sender_ draggingLocation]];
  if( cell ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)_sender_ {
  ELHex *cell = [self cellUnderMouseLocation:[_sender_ draggingLocation]];
  if( cell ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (void)draggingExited:(id <NSDraggingInfo>)_sender_ {
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)_sender_ {
  NSPasteboard *pasteboard = [_sender_ draggingPasteboard];
  NSArray *types = [pasteboard types];
  if( [types containsObject:ToolPBoardType] ) {
    int tag = [[pasteboard stringForType:ToolPBoardType] intValue];
    [self addTool:tag toCell:[self cellUnderMouseLocation:[_sender_ draggingLocation]]];
  } else if( [types containsObject:HexPBoardType] ) {
    [self dragFromHex:[self selectedHex] to:[self cellUnderMouseLocation:[_sender_ draggingLocation]] with:[_sender_ draggingSourceOperationMask]];
  }
  
  return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)_sender_ {
}

- (void)cellWasUpdated:(NSNotification*)_notification_
{
  [self setNeedsDisplay:YES];
}

@end
