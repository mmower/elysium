//
//  ELLayerView.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHexCell;

@interface ELLayerView : NSView {
  NSMutableArray    *hexes;
  ELHexCell         *selection;
  
  id                delegate;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (ELHexCell *)findHexAtPoint:(NSPoint)point;

@end

// Define a category on NSObject for our delegate methods
@interface NSObject (ELLayerViewDelegate)
- (void)layerView:(ELLayerView *)layerView hexSelected:(ELHexCell *)hex;
@end
