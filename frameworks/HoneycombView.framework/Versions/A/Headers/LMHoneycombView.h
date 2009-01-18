//
//  LMHoneycombView.h
//  Elysium
//
//  Created by Matt Mower on 29/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHoneycombMatrix.h>

@class LMHexCell;

extern NSString* const LMHoneycombViewDefaultColor;
extern NSString* const LMHoneycombViewSelectedColor;
extern NSString* const LMHoneycombViewBorderColor;
extern NSString* const LMHoneycombViewSelectedBorderColor;
extern NSString* const LMHoneycombViewBorderWidth;

@interface LMHoneycombView : NSView {
  LMHexCell             *selected;
  
  id<LMHoneycombMatrix> dataSource;
  id                    delegate;
  
  int                   cols;
  int                   rows;
  
  BOOL                  firstDrawing;
  
  NSMutableDictionary   *drawingAttributes;
}

@property (readonly) NSMutableDictionary *drawingAttributes;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (id<LMHoneycombMatrix>)dataSource;
- (void)setDataSource:(id<LMHoneycombMatrix>)dataSource;
- (void)dataSourceChanged;

- (LMHexCell *)selected;
- (void)setSelected:(LMHexCell *)selected;

- (CGFloat)hexRadius;
- (CGFloat)hexOffset:(CGFloat)radius;
- (CGFloat)hexHeight:(CGFloat)radius;
- (CGFloat)idealHeight:(CGFloat)radius;
- (CGFloat)layerAspectRatio;

- (NSColor *)selectedColor;
- (void)setSelectedColor:(NSColor *)selectedColor;
- (NSColor *)defaultColor;
- (void)setDefaultColor:(NSColor *)defaultColor;
- (NSColor *)borderColor;
- (void)setBorderColor:(NSColor *)borderColor;
- (NSColor *)selectedBorderColor;
- (void)setSelectedBorderColor:(NSColor *)selectedBorderColor;
- (CGFloat)borderWidth;
- (void)setBorderWidth:(CGFloat)borderWidth;

- (LMHexCell *)findCellAtPoint:(NSPoint)point;

- (void)calculateCellPaths:(NSRect)bounds;

@end

// Define a category on NSObject for our delegate methods
@interface NSObject (LMHoneycombViewDelegate)
- (void)honeycombView:(LMHoneycombView *)honeycombView hexCellSelected:(LMHexCell *)cell;
@end
