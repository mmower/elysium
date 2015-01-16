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
  LMHexCell             *_selected;
  
  id<LMHoneycombMatrix> _dataSource;
  id                    _delegate;
  
  int                   _cols;
  int                   _rows;
  
  BOOL                  _recalculateCellPaths;
  
  NSBitmapImageRep      *_viewCache;
  
  NSMutableDictionary   *_drawingAttributes;
}

@property (readonly) NSMutableDictionary *drawingAttributes;
@property (readonly) int cols;
@property (readonly) int rows;
@property id delegate;
@property BOOL recalculateCellPaths;
@property LMHexCell *selected;
@property id<LMHoneycombMatrix> dataSource;

- (void)dataSourceChanged;

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
