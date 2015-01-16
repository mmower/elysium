//
//  ELSurfaceView.h
//  Elysium
//
//  Created by Matt Mower on 29/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHoneycombView.h>

@class ELCell;

@interface ELSurfaceView : LMHoneycombView <NSDraggingSource> {
    NSMutableArray *octaveColors;
    // NSColor         *tokenColor;
    NSEvent *savedEvent;
}

@property  (nonatomic,assign)  NSColor *tokenColor;

- (void)setActivePlayheadColor:(NSColor *)color;
- (NSColor *)activePlayheadColor;
- (void)setTonicNoteColor:(NSColor *)color;
- (NSColor *)tonicNoteColor;
- (void)setScaleNoteColor:(NSColor *)color;
- (NSColor *)scaleNoteColor;
- (NSColor *)octaveColor:(int)octave;

- (ELCell *)cellUnderMouseLocation:(NSPoint)point;
- (ELCell *)selectedCell;

- (void)dragFromCell:(ELCell *)sourceCell to:(ELCell *)targetCell with:(NSDragOperation)modifiers;

- (void)cellWasUpdated:(NSNotification *)notification;

- (NSWindow *)draggingDestinationWindow;
- (NSDragOperation)draggingSourceOperationMask;
- (NSPoint)draggingLocation;
@end
