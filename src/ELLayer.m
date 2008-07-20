//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELLayer.h"

#import "ELHex.h"
#import "ELTool.h"
#import "ELHarmonicTable.h"

@implementation ELLayer

- (id)initWithHarmonicTable:(ELHarmonicTable *)_harmonicTable instrument:(int)_instrument config:(NSMutableDictionary *)_config {
  if( self = [super init] ) {
    harmonicTable = _harmonicTable;
    instrument = _instrument;
    config = _config;
    hexes = [[NSMutableArray alloc] initWithCapacity:[harmonicTable size]];
    [self configureHexes];
  }
  
  return self;
}

- (void)run {
  
}

- (void)stop {
  
}

- (void)reset {
  [self removeAllPlayheads];
  [self pulse];
}

- (void)removeAllPlayheads {
  [playheads removeAllObjects];
}

- (void)pulse {
  for( ELHex *hex in hexes ) {
    for( ELTool *tool in [hex toolsOfType:@"start"] ) {
      [tool run:nil];
    }
  }
}

- (ELHex *)hexAtCol:(int)_col row:(int)_row {
  return [hexes objectAtIndex:COL_ROW_OFFSET(_col,_row)];
}

- (void)configureHexes {
  // First build the hex table mapping
  for( int col = 0; col < [harmonicTable cols]; col++ ) {
    for( int row = 0; row < [harmonicTable rows]; row++ ) {
      [hexes insertObject:[[ELHex alloc] initWithLayer:self
                                                  note:[harmonicTable noteAtCol:col row:row]
                                                   col:col
                                                   row:row] atIndex:COL_ROW_OFFSET(col,row)];
    }
  }

  // Now connect the hexes up graph style
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELHex *hex = [self hexAtCol:col row:row];

      // North Hex
      if( row < HTABLE_MAX_ROW ) {
        [hex connectNeighbour:[self hexAtCol:col row:row+1] direction:N];
      }

      // South Hex
      if( row > 0 ) {
        [hex connectNeighbour:[self hexAtCol:col row:row-1] direction:S];
      }

      // Easterly Hexes
      if( col % 2 == 0 ) {
        if( col < HTABLE_MAX_COL ) {
          [hex connectNeighbour:[self hexAtCol:col+1 row:row] direction:NE];
          if( row > 0 ) {
            [hex connectNeighbour:[self hexAtCol:col+1 row:row-1] direction:SE];
          }
        }
      } else {
        if( row < HTABLE_MAX_ROW ) {
          [hex connectNeighbour:[self hexAtCol:col+1 row:row+1] direction:NE];
        }
        [hex connectNeighbour:[self hexAtCol:col+1 row:row] direction:SE];
      }

      // Westerly Hexes
      if( col % 2 == 0 ) {
        if( col > 0 ) {
          [hex connectNeighbour:[self hexAtCol:col-1 row:row] direction:NW];
          if( row > 0 ) {
            [hex connectNeighbour:[self hexAtCol:col-1 row:row-1] direction:SW];
          }
        }
      } else {
        if( row < HTABLE_MAX_ROW ) {
          [hex connectNeighbour:[self hexAtCol:col-1 row:row+1] direction:NW];
        }
        [hex connectNeighbour:[self hexAtCol:col-1 row:row] direction:SW];
      }
    }
  }
}

@end
