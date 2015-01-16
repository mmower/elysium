//
//  LMHoneycombMatrix.h
//  Elysium
//
//  Created by Matt Mower on 29/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LMHexCell;

@protocol LMHoneycombMatrix

- (int)hexColumns;
- (int)hexRows;
- (LMHexCell *)hexCellAtColumn:(int)column row:(int)row;
- (void)hexCellSelected:(LMHexCell *)cell;

@end
