//
//  ELHexCell.h
//  Elysium
//
//  Created by Matt Mower on 24/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELLayerView;

@interface ELHexCell : NSObject {
  ELLayerView         *layerView;
  NSBezierPath        *path;
  int                 col;
  int                 row;
}

- (id)initWithLayerView:(ELLayerView *)layerView column:(int)col row:(int)row;

- (ELLayerView *)layerView;

- (NSBezierPath *)path;
- (void)setPath:(NSBezierPath *)path;

- (int)column;
- (int)row;

@end
