//
//  ELSurfaceView.m
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSurfaceView.h"

#import "ELCell.h"
#import "ELLayer.h"

#import "ELNoteToken.h"
#import "ELAbsorbToken.h"
#import "ELSpinToken.h"
#import "ELGenerateToken.h"
#import "ELReboundToken.h"
#import "ELSplitToken.h"

NSString *CellPBoardType = @"CellPBoardType";

static ELSurfaceView *dragStartView = nil;

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
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self setDefaultColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultCellBackgroundColor]]];
    [self setBorderColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultCellBorderColor]]];
    [self setSelectedColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultSelectedCellBackgroundColor]]];
    [self setSelectedBorderColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultSelectedCellBorderColor]]];
    [self setTokenColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultTokenColor]]];
    [self setActivePlayheadColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELDefaultActivePlayheadColor]]];
    [self setTonicNoteColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELTonicNoteColor]]];
    [self setScaleNoteColor:[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:ELScaleNoteColor]]];
    
    [self registerForDraggedTypes:[NSArray arrayWithObjects:CellPBoardType,nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellWasUpdated:)
                                                 name:ELNotifyCellWasUpdated
                                               object:nil];
  }
  
  return self;
}

@dynamic tokenColor;

- (void)setTokenColor:(NSColor *)_color_ {
  [[self drawingAttributes] setObject:_color_ forKey:ELDefaultTokenColor];
}

- (NSColor *)tokenColor {
  return [[self drawingAttributes] objectForKey:ELDefaultTokenColor];
}

- (void)setActivePlayheadColor:(NSColor *)_color_ {
  [[self drawingAttributes] setObject:_color_ forKey:ELDefaultActivePlayheadColor];
}

- (NSColor *)activePlayheadColor {
  return [[self drawingAttributes] objectForKey:ELDefaultActivePlayheadColor];
}

- (void)setTonicNoteColor:(NSColor *)_color_ {
  [[self drawingAttributes] setObject:_color_ forKey:ELTonicNoteColor];
}

- (NSColor *)tonicNoteColor {
  return [[self drawingAttributes] objectForKey:ELTonicNoteColor];
}

- (void)setScaleNoteColor:(NSColor *)_color_ {
  [[self drawingAttributes] setObject:_color_ forKey:ELScaleNoteColor];
}

- (NSColor *)scaleNoteColor {
  return [[self drawingAttributes] objectForKey:ELScaleNoteColor];
}

- (NSColor *)octaveColor:(int)_octave_ {
  return [octaveColors objectAtIndex:_octave_];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)_event_ {
  return YES;
}

// General view support

- (ELCell *)cellUnderMouseLocation:(NSPoint)_point_ {
  return (ELCell *)[self findCellAtPoint:[self convertPoint:_point_ fromView:nil]];
}

- (ELCell *)selectedCell {
  return (ELCell *)[self selected];
}

// Token management

- (void)dragFromCell:(ELCell *)sourceCell to:(ELCell *)targetCell with:(NSDragOperation)modifiers {
  NSUndoManager *undoManager = [[[[targetCell layer] player] document] undoManager];
  [undoManager beginUndoGrouping];
  [targetCell removeAllTokensWithUndo];
  [targetCell copyTokensFrom:sourceCell];
  if( !modifiers & NSDragOperationCopy ) {
    [sourceCell removeAllTokensWithUndo];
  }
  [undoManager setActionName:(modifiers & NSDragOperationCopy ? @"copy" : @"move")];
  [undoManager endUndoGrouping];
  [self setNeedsDisplay:YES];
}

// Cell-to-Cell drag support

- (NSDragOperation)draggingSourceOperationMaskForLocal:(BOOL)isLocal {
  if( isLocal ) {
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
  [pasteboard declareTypes:[NSArray arrayWithObject:CellPBoardType] owner:self];
  
  [pasteboard setString:@"SonOfCell" forType:CellPBoardType]; // Dummy, we'll just work of [self selected] anyway
  
  dragStartView = self;
  
  [self dragImage:image
               at:p
           offset:NSMakeSize(0,0)
            event:savedEvent
       pasteboard:pasteboard
           source:self
        slideBack:YES];
}

// Drag & Drop Token adding support

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
  ELCell *cell = [self cellUnderMouseLocation:[sender draggingLocation]];
  if( cell && [[[dragStartView selectedCell] layer] player] == [[cell layer] player] ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender {
  ELCell *cell = [self cellUnderMouseLocation:[sender draggingLocation]];
  if( cell && [[[dragStartView selectedCell] layer] player] == [[cell layer] player] ) {
    return NSDragOperationCopy;
  } else {
    return NSDragOperationNone;
  }
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
  NSPasteboard *pasteboard = [sender draggingPasteboard];
  NSArray *types = [pasteboard types];
  
  ELCell *droppedCell = [self cellUnderMouseLocation:[sender draggingLocation]];
  if( [types containsObject:CellPBoardType] ) {
    ELCell *sourceCell = [dragStartView selectedCell];
    if( sourceCell != droppedCell ) {
      [self dragFromCell:sourceCell to:droppedCell with:[sender draggingSourceOperationMask]];
    }
  }
  
  return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender {
}

- (void)cellWasUpdated:(NSNotification*)notification {
  [self setNeedsDisplay:YES];
}

@end
