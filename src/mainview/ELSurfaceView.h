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

@class ELHex;

@interface ELSurfaceView : LMHoneycombView {
  NSMutableArray  *octaveColors;
  NSColor         *tokenColor;
  NSEvent         *savedEvent;
}

@property (assign) NSColor *tokenColor;

- (void)setActivePlayheadColor:(NSColor *)color;
- (NSColor *)activePlayheadColor;
- (void)setTonicNoteColor:(NSColor *)color;
- (NSColor *)tonicNoteColor;
- (void)setScaleNoteColor:(NSColor *)color;
- (NSColor *)scaleNoteColor;
- (NSColor *)octaveColor:(int)octave;

- (ELHex *)cellUnderMouseLocation:(NSPoint)point;
- (ELHex *)selectedHex;

- (void)dragFromHex:(ELHex *)sourceHex to:(ELHex *)targetHex with:(NSDragOperation)modifiers;

- (void)cellWasUpdated:(NSNotification*)notification;
    
@end
