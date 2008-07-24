//
//  ELHexCell.m
//  Elysium
//
//  Created by Matt Mower on 24/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELHexCell.h"

#import "ELLayerView.h"

@implementation ELHexCell

- (id)initWithLayerView:(ELLayerView *)_layerView path:(NSBezierPath *)_path column:(int)_col row:(int)_row {
  if( self = [super init] ) {
    layerView = _layerView;
    path      = _path;
    col       = _col;
    row       = _row;
  }
  
  return self;
}

- (ELLayerView *)layerView {
  return layerView;
}

- (NSBezierPath *)path {
  return path;
}

- (int)column {
  return col;
}

- (int)row {
  return row;
}

@end
