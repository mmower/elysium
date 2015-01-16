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

extern NSString *const LMHoneycombViewDefaultColor;
extern NSString *const LMHoneycombViewSelectedColor;
extern NSString *const LMHoneycombViewBorderColor;
extern NSString *const LMHoneycombViewSelectedBorderColor;
extern NSString *const LMHoneycombViewBorderWidth;

@interface LMHoneycombView : NSView {
    LMHexCell *mSelected;
    
    id <LMHoneycombMatrix> mDataSource;
    id mDelegate;
    
    int mCols;
    int mRows;
    
    BOOL mRecalculateCellPaths;
    
    NSBitmapImageRep *mViewCache;
    
    NSMutableDictionary *mDrawingAttributes;
}

@property (readonly, nonatomic, getter = drawingAttributes) NSMutableDictionary *mDrawingAttributes;
@property (readonly, nonatomic, getter = cols) int mCols;
@property (readonly, nonatomic, getter = rows) int mRows;
@property (nonatomic, assign, getter = delegate, setter = setDelegate :) id mDelegate;
@property (getter = recalculateCellPaths, setter = setRecalculateCellPaths :) BOOL mRecalculateCellPaths;
@property (nonatomic, strong, getter = selected, setter = setSelected :) LMHexCell *mSelected;
@property (nonatomic, strong, getter = dataSource, setter = setDataSource :) id <LMHoneycombMatrix> mDataSource;

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
