//
//  ELLayerView.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHexCell;
@class ELLayer;

@interface ELLayerView : NSView {
  NSMutableArray    *hexes;
  ELHexCell         *selected;
  
  id                delegate;
  ELLayer           *dataLayer;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (ELLayer *)dataLayer;
- (void)setDataLayer:(ELLayer *)layer;

- (ELHexCell *)selected;
- (void)setSelected:(ELHexCell *)selected;

- (NSColor *)defaultColor;
- (NSColor *)selectedColor;

- (CGFloat)hexRadius;
- (CGFloat)hexOffset;
- (CGFloat)hexDiameter;
- (CGFloat)idealHeight;

- (ELHexCell *)findHexAtPoint:(NSPoint)point;

- (void)generateCells;
- (void)calculateCellPaths:(NSRect)bounds;

@end

// Define a category on NSObject for our delegate methods
@interface NSObject (ELLayerViewDelegate)
- (void)layerView:(ELLayerView *)layerView hexSelected:(ELHexCell *)hex;
@end
