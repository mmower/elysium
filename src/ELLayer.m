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
#import "ELNote.h"
#import "ELTool.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELHarmonicTable.h"

@implementation ELLayer

- (id)initWithPlayer:(ELPlayer *)_player config:(ELConfig *)_config {
  if( self = [super init] ) {
    player        = _player;
    config        = _config;
    hexes         = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    playheads     = [[NSMutableArray alloc] init];
    beatCount     = 0;
    
    [self configureHexes];
  }
  
  return self;
}

- (ELPlayer *)player {
  return player;
}

- (void)run {
  NSLog( @"Layer %@ is running", self );
  
  // On the first and every pulseCount beats, generate new playheads
  NSLog( @"beatCount = %d, pulseCount = %d", beatCount, [self pulseCount] );
  
  if( beatCount % [self pulseCount] == 0 ) {
    [self pulse];
  }
  
  // Run all current playheads
  for( ELPlayhead *playhead in playheads ) {
    ELHex *hex = [playhead position];
    for( ELTool *tool in [hex toolsExceptType:@"start"] ) {
      [tool run:playhead];
      [playhead advance];
    }
  }
  
  // Delete dead playheads
  [playheads filterUsingPredicate:[NSPredicate predicateWithFormat:@"isDead == TRUE"]];
  
  // Beat is over
  beatCount++;
}

- (void)playNote:(ELNote *)_note velocity:(int)_velocity duration:(float)_duration {
  [player playNote:_note
           channel:[self channel]
          velocity:_velocity
          duration:_duration];
}

- (int)channel {
  return [config integerForKey:@"channel"];
}

- (int)pulseCount {
  return [config integerForKey:@"pulseCount"];
}

- (void)stop {
  [self removeAllPlayheads];
}

- (void)reset {
  beatCount = 0;
  [self removeAllPlayheads];
}

- (void)addPlayhead:(ELPlayhead *)_playhead {
  [playheads addObject:_playhead];
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
  ELHarmonicTable *harmonicTable = [player harmonicTable];
  
  // First build the hex table mapping
  for( int col = 0; col < [harmonicTable cols]; col++ ) {
    for( int row = 0; row < [harmonicTable rows]; row++ ) {
      ELHex *hex = [[ELHex alloc] initWithLayer:self
                                           note:[harmonicTable noteAtCol:col row:row]
                                         column:col
                                            row:row];
                                            
      [hexes addObject:hex];
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

// LMHoneycombMatrix protocol implementation

- (int)hexColumns {
  return HTABLE_COLS;
}

- (int)hexRows {
  return HTABLE_ROWS;
}

- (void)hexCellSelected:(LMHexCell *)_cell {
  NSLog( @"Layer selected cell at %d, %d", [_cell column], [_cell row] );
  [self playNote:[(ELHex*)_cell note] velocity:100 duration:0.8];
}

- (LMHexCell *)hexCellAtColumn:(int)_col row:(int)_row {
  return [hexes objectAtIndex:COL_ROW_OFFSET(_col,_row)];
}


@end
