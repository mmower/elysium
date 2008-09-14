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
    octaveColors = [[NSMutableArray alloc] init];
    [octaveColors addObject:[NSColor grayColor]]; // We don't see Octave#0 anyway
    [octaveColors addObject:[NSColor colorWithDeviceRed:(234.0/255) green:(174.0/255) blue:(145.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(231.0/255) green:(214.0/255) blue:(148.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(212.0/255) green:(228.0/255) blue:(150.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(176.0/255) green:(225.0/255) blue:(152.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(155.0/255) green:(222.0/255) blue:(165.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(158.0/255) green:(218.0/255) blue:(203.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(165.0/255) green:(172.0/255) blue:(210.0/255) alpha:0.9]];
    [octaveColors addObject:[NSColor colorWithDeviceRed:(192.0/255) green:(169.0/255) blue:(205.0/255) alpha:0.9]];
    
    [self setDefaultColor:[NSColor colorWithDeviceRed:(12.0/255) green:(153.0/255) blue:(206.0/255) alpha:0.8]];
    [self setBorderColor:[NSColor colorWithDeviceRed:(58.0/255) green:(46.0/255) blue:(223.0/255) alpha:0.8]];
    [self setSelectedBorderColor:[NSColor colorWithDeviceRed:(179.0/255) green:(158.0/255) blue:(241.0/255) alpha:0.8]];
    [self setSelectedColor:[NSColor colorWithDeviceRed:(108.0/255) green:(69.0/255) blue:(229.0/255) alpha:0.8]];
    [self setToolColor:[NSColor colorWithDeviceRed:(16.0/255) green:(17.0/255) blue:(156.0/255) alpha:0.8]];
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

- (NSColor *)octaveColor:(int)_octave_ {
  return [octaveColors objectAtIndex:_octave_];
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
  
  // Let's update the selected hex that was dropped on
  [self setSelected:_cell_];
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
