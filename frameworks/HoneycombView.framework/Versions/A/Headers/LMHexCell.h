//
//  LMHexCell.h
//  Elysium
//
//  Created by Matt Mower on 29/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMHoneycombView;

@interface LMHexCell : NSObject {
    NSPoint mCentre;
    CGFloat mRadius;
    NSBezierPath *mPath;
    int mCol;
    int mRow;
    id mData;
    BOOL mSelected;
    BOOL mDirty;
}

- (id)initWithColumn:(int)col row:(int)row;
- (id)initWithColumn:(int)col row:(int)row data:(id)data;

@property (readonly, nonatomic) int column;
@property (readonly, nonatomic) int row;

@property (readonly, getter = centre) NSPoint mCentre;
@property (readonly, getter = radius) CGFloat mRadius;
@property (readonly, getter = path) NSBezierPath *mPath;
@property (readonly, getter = col) int mCol;
@property (readonly, getter = row) int mRow;
@property (nonatomic, assign, getter = data, setter = setData:) id mData;
@property (nonatomic, getter = selected, setter = setSelected:) BOOL mSelected;
@property (getter = dirty, setter = setDirty:) BOOL mDirty;

- (void)setHexCentre:(NSPoint)centre radius:(CGFloat)radius;
- (void)drawOnHoneycombView:(LMHoneycombView *)view withAttributes:(NSMutableDictionary *)attributes;
- (NSMenu *)contextMenu;

@end
