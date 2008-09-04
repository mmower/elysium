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
#import "ELConfig.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELHarmonicTable.h"

#import "ELInspectorController.h"

@implementation ELLayer

- (id)initWithPlayer:(ELPlayer *)_player channel:(int)_channel {
  if( self = [super init] ) {
    player    = _player;
    config    = [[ELConfig alloc] init];
    hexes     = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    playheads = [[NSMutableArray alloc] init];
    beatCount = 0;
    
    [self configureHexes];
    
    [config setParent:[player config]];
    [config setInteger:_channel forKey:@"channel"];
  }
  
  return self;
}

@synthesize player;
@synthesize config;

- (void)run {
  NSPredicate *deadPlayheadFilter = [NSPredicate predicateWithFormat:@"isDead != TRUE"];
  
  // On the first and every pulseCount beats, generate new playheads
  // NSLog( @"beatCount = %d, pulseCount = %d", beatCount, [self pulseCount] );
  if( beatCount % [self pulseCount] == 0 ) {
    [self pulse];
  }
  
  // Run all current playheads
  for( ELPlayhead *playhead in [playheads copy] ) {
    ELHex *hex = [playhead position];
    for( ELTool *tool in [hex toolsExceptType:@"start"] ) {
      if( ![playhead isDead] ) {
        [tool run:playhead];
      }
    }
    
    if( ![playhead isDead] ) {
      [playhead advance];
    }
  }
  
  // Cleanup & delete dead playheads
  for( ELPlayhead *playhead in playheads ) {
    [playhead cleanup];
  }
  [playheads filterUsingPredicate:deadPlayheadFilter];
  
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

- (void)setChannel:(int)_channel_ {
  [config setInteger:_channel_ forKey:@"channel"];
}

- (int)tempo {
  return [config integerForKey:@"bpm"];
}

- (void)setTempo:(int)_tempo_ {
  [config setInteger:_tempo_ forKey:@"bpm"];
}

- (int)velocity {
  return [config integerForKey:@"velocity"];
}

- (void)setVelocity:(int)_velocity_ {
  [config setInteger:_velocity_ forKey:@"velocity"];
}

- (float)duration {
  return [config floatForKey:@"duration"];
}

- (void)setDuration:(float)_duration {
  [config setFloat:_duration forKey:@"duration"];
}

- (int)pulseCount {
  return [config integerForKey:@"pulseCount"];
}

- (void)setPulseCount:(int)_pulseCount_ {
  [config setInteger:_pulseCount_ forKey:@"pulseCount"];
}

- (int)timeToLive {
  return [config integerForKey:@"ttl"];
}

- (void)setTimeToLive:(int)_ttl_ {
  [config setInteger:_ttl_ forKey:@"ttl"];
}

- (void)stop {
  [self removeAllPlayheads];
}

- (void)reset {
  beatCount = 0;
  [self removeAllPlayheads];
}

- (void)clear {
  [hexes makeObjectsPerformSelector:@selector(removeAllTools)];
}

- (void)addPlayhead:(ELPlayhead *)_playhead {
  [playheads addObject:_playhead];
}

- (void)removeAllPlayheads {
  for( ELPlayhead *playhead in playheads ) {
    [playhead setPosition:nil];
  }
  [playheads removeAllObjects];
}

- (void)pulse {
  for( ELHex *hex in hexes ) {
    [[hex toolOfType:@"start"] run:nil];
  }
}

- (void)configureHexes {
  ELHarmonicTable *harmonicTable = [player harmonicTable];
  NSAssert( harmonicTable != nil, @"Harmonic table should never be nil" );
  
  NSAssert( hexes != nil, @"hexes have not been initialized!" );
  
  // First build the hex table mapping
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELNote *note = [harmonicTable noteAtCol:col row:row];
      NSAssert( note != nil, @"Note should never be nil" );
      
      ELHex *hex = [[ELHex alloc] initWithLayer:self
                                           note:note
                                         column:col
                                            row:row];
      NSAssert( hex != nil, @"Generated hexes should never be nil" );
      
      [hexes addObject:hex];
    }
  }

  // Now connect the hexes up graph style
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELHex *hex = [self hexAtColumn:col row:row];
      
      // North Hex
      if( row < HTABLE_MAX_ROW ) {
        [hex connectNeighbour:[self hexAtColumn:col row:row+1] direction:N];
      }
      
      // // South Hex
      if( row > 0 ) {
        [hex connectNeighbour:[self hexAtColumn:col row:row-1] direction:S];
      }

      // Easterly Hexes
      if( col % 2 == 0 ) {
        if( col < HTABLE_MAX_COL ) {
          if( row < HTABLE_MAX_ROW ) {
            [hex connectNeighbour:[self hexAtColumn:col+1 row:row+1] direction:NE];
          }
          [hex connectNeighbour:[self hexAtColumn:col+1 row:row] direction:SE];
        }
      } else {
        [hex connectNeighbour:[self hexAtColumn:col+1 row:row] direction:NE];
        if( row > 0 ) {
          [hex connectNeighbour:[self hexAtColumn:col+1 row:row-1] direction:SE];
        }
      }

      // Westerly Hexes
      if( col % 2 == 0 ) {
        if( col > 0 ) {
          if( row < HTABLE_MAX_ROW ) {
            [hex connectNeighbour:[self hexAtColumn:col-1 row:row+1] direction:NW];
          }
          [hex connectNeighbour:[self hexAtColumn:col-1 row:row] direction:SW];
        }
      } else {
        [hex connectNeighbour:[self hexAtColumn:col-1 row:row] direction:NW];
        if( row > 0 ) {
          [hex connectNeighbour:[self hexAtColumn:col-1 row:row-1] direction:SW];
        }
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
  NSLog( @"Selected hex: %@", _cell );
  
  if( _cell ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:_cell];
    [self playNote:[(ELHex*)_cell note] velocity:[self velocity] duration:[self duration]];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:self];
  }
}

- (ELHex *)hexAtColumn:(int)_col row:(int)_row {
  return (ELHex *)[self hexCellAtColumn:_col row:_row];
}

- (LMHexCell *)hexCellAtColumn:(int)_col row:(int)_row {
  LMHexCell *cell = [hexes objectAtIndex:COL_ROW_OFFSET(_col,_row)];
  NSAssert2( cell != nil, @"Requested nil hex at %d,%d", _col, _row );
  return cell;
}

// Implementing the ELData Protocol

- (NSXMLElement *)asXMLData {
  NSXMLElement *layerElement = [NSXMLNode elementWithName:@"layer"];
  
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[config stringForKey:@"channel"] forKey:@"channel"];
  if( [config definesValueForKey:@"pulseCount"] ) {
    [attributes setObject:[config stringForKey:@"pulseCount"] forKey:@"pulseCount"];
  }
  if( [config definesValueForKey:@"velocity"] ) {
    [attributes setObject:[config stringForKey:@"velocity"] forKey:@"velocity"];
  }
  if( [config definesValueForKey:@"duration"] ) {
    [attributes setObject:[config stringForKey:@"duration"] forKey:@"duration"];
  }
  if( [config definesValueForKey:@"bpm"] ) {
    [attributes setObject:[config stringForKey:@"bpm"] forKey:@"bpm"];
  }
  if( [config definesValueForKey:@"ttl"] ) {
    [attributes setObject:[config stringForKey:@"ttl"] forKey:@"ttl"];
  }
  [layerElement setAttributesAsDictionary:attributes];
  
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELHex *hex = [self hexAtColumn:col row:row];
      
      if( [[hex tools] count] > 0 ) {
        [layerElement addChild:[hex asXMLData]];
      }
    }
  }
  
  return layerElement;
}

- (BOOL)fromXMLData:(NSXMLElement *)_xml_ {
  
  NSXMLNode *node;
  if( node = [_xml_ attributeForName:@"pulseCount"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"pulseCount"];
  }
  if( node = [_xml_ attributeForName:@"velocity"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"velocity"];
  }
  if( node = [_xml_ attributeForName:@"duration"] ) {
    [config setInteger:[[node stringValue] floatValue] forKey:@"duration"];
  }
  if( node = [_xml_ attributeForName:@"bpm"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"bpm"];
  }
  if( node = [_xml_ attributeForName:@"ttl"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"ttl"];
  }
  
  for( NSXMLNode *cellNode in [_xml_ nodesForXPath:@"cell" error:nil] ) {
    NSXMLElement *cellElement = (NSXMLElement *)cellNode;
    
    if( !( node = [cellElement attributeForName:@"col"] ) ) {
      NSLog( @"Found cell with no column!" );
      return NO;
    }
    int col = [[node stringValue] intValue];
    
    if( !( node = [cellElement attributeForName:@"row"] ) ) {
      NSLog( @"Found cell with no row!" );
      return NO;
    }
    int row = [[node stringValue] intValue];
    
    ELHex *hex = [self hexAtColumn:col row:row];
    if( !hex ) {
      NSLog( @"Cell reference %d,%d is invalid", col, row );
      return NO;
    }
    
    if( ![hex fromXMLData:cellElement] ) {
      NSLog( @"Problem loading cell %d,%d", col, row );
      return NO;
    }
  }
  
  return YES;
}

// Drawing notification from the hex

- (void)needsDisplay {
  [player needsDisplay];
}

@end
