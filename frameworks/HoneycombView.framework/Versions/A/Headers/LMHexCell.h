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
  NSPoint             centre;
  CGFloat             radius;
  NSBezierPath        *path;
  int                 col;
  int                 row;
  id                  data;
  BOOL                selected;
}

- (id)initWithColumn:(int)col row:(int)row;
- (id)initWithColumn:(int)col row:(int)row data:(id)data;

- (NSBezierPath *)path;
- (void)setHexCentre:(NSPoint)centre radius:(CGFloat)radius;

- (NSPoint)centre;
- (CGFloat)radius;

- (id)data;
- (void)setData:(id)data;

- (int)column;
- (int)row;

- (BOOL)selected;
- (void)setSelected:(BOOL)selected;

- (void)drawOnHoneycombView:(LMHoneycombView *)view withAttributes:(NSMutableDictionary *)attributes;

- (NSMenu *)contextMenu;

@end
