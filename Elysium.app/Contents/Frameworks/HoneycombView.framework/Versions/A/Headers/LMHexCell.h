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
  NSPoint             _centre;
  CGFloat             _radius;
  NSBezierPath        *_path;
  int                 _col;
  int                 _row;
  id                  _data;
  BOOL                _selected;
  BOOL                _needsRedraw;
}

- (id)initWithColumn:(int)col row:(int)row;
- (id)initWithColumn:(int)col row:(int)row data:(id)data;

@property (readonly) NSPoint centre;
@property (readonly) CGFloat radius;
@property (readonly) NSBezierPath *path;
@property (readonly) int col;
@property (readonly) int column;
@property (readonly) int row;
@property id data;
@property BOOL selected;
@property BOOL needsRedraw;

- (void)setHexCentre:(NSPoint)centre radius:(CGFloat)radius;
- (void)drawOnHoneycombView:(LMHoneycombView *)view withAttributes:(NSMutableDictionary *)attributes;
- (NSMenu *)contextMenu;

@end
