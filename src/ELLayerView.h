//
//  ELLayerView.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef struct tagELFoundHex {
  BOOL            found;
  NSBezierPath    *path;
  int             col;
  int             row;
} ELFoundHex;

@interface ELLayerView : NSView {
  NSMutableArray    *hexes;
  int               selectedCol;
  int               selectedRow;
  
  id                delegate;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (ELFoundHex)findHexAtPoint:(NSPoint)point;

@end

// Define a category on NSObject for our delegate methods
@interface NSObject (ELLayerViewDelegate)
- (void)hexSelected:(ELLayerView *)layerView column:(int)col row:(int)row;
@end
