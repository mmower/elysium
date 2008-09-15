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
#import "ELStartTool.h"
#import "ELHarmonicTable.h"

#import "ELInspectorController.h"

NSPredicate *deadPlayheadFilter;

@implementation ELLayer

+ (NSPredicate *)deadPlayheadFilter {
  if( !deadPlayheadFilter ) {
    deadPlayheadFilter = [NSPredicate predicateWithFormat:@"isDead != TRUE"];
  }
  
  return deadPlayheadFilter;
}

- (id)initWithPlayer:(ELPlayer *)_player_ channel:(int)_channel_ {
  if( ( self = [super init] ) ) {
    player     = _player_;
    hexes      = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    playheads  = [[NSMutableArray alloc] init];
    generators = [[NSMutableArray alloc] init];
    beatCount  = 0;
    timeBase   = 0;
    isRunning  = 0;
    
    [self configureHexes];
    
    enabledKnob    = [[ELBooleanKnob alloc] initWithName:@"enabled" booleanValue:YES];
    channelKnob    = [[ELIntegerKnob alloc] initWithName:@"channel" integerValue:_channel_];
    tempoKnob      = [[ELIntegerKnob alloc] initWithName:@"tempo"];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive"];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount"];
    velocityKnob   = [[ELIntegerKnob alloc] initWithName:@"velocity"];
    durationKnob   = [[ELFloatKnob alloc] initWithName:@"duration"];
    
    [tempoKnob setLinkedKnob:[player tempoKnob]];
    [timeToLiveKnob setLinkedKnob:[player timeToLiveKnob]];
    [pulseCountKnob setLinkedKnob:[player pulseCountKnob]];
    [velocityKnob setLinkedKnob:[player velocityKnob]];
    [durationKnob setLinkedKnob:[player durationKnob]];
  }
  
  return self;
}

@synthesize player;
@synthesize delegate;
@synthesize layerId;

@synthesize enabledKnob;
@synthesize channelKnob;
@synthesize tempoKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize durationKnob;

- (void)playNote:(ELNote *)_note_ velocity:(int)_velocity_ duration:(float)_duration_ {
  // UInt64 noteOnTime = timeBase + (beatCount * [self timerResolution]);
  // UInt64 noteOffTime = noteOnTime + ( _duration_ * 1000000 );
  // [player scheduleNote:_note_ channel:[self channel] velocity:[self velocity] on:noteOnTime off:noteOffTime];
  [player playNote:_note_ channel:[channelKnob value] velocity:_velocity_ duration:_duration_];
}

- (int)timerResolution {
  return 60000000 / [[self tempoKnob] value];
}

@dynamic visible;

- (BOOL)visible {
  return [[delegate window] isVisible];
}

- (void)setVisible:(BOOL)_visible_ {
  if( _visible_ ) {
    [[delegate window] makeKeyAndOrderFront:self];
  } else {
    [[delegate window] orderOut:self];
  }
}

// Manipulate layer

- (void)run {
  if( [enabledKnob value] ) {
    // On the first and every pulseCount beats, generate new playheads
    // NSLog( @"beatCount = %d, pulseCount = %d", beatCount, [self pulseCount] );
    [self pulse];
    
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
    
    [playheads filterUsingPredicate:[ELLayer deadPlayheadFilter]];
    
    [delegate setNeedsDisplay:YES];
  }
  
  // Beat is over
  beatCount++;
}

- (void)runLayer {
  timeBase  = AudioGetCurrentHostTime();
  isRunning = YES;
  while( ![runner isCancelled] ) {
    [self run];
    usleep( [self timerResolution] );
  }
  
  isRunning = NO;
  [self reset];
}

- (void)start {
  runner = [[NSThread alloc] initWithTarget:self selector:@selector(runLayer) object:nil];
  [runner start];
}

- (void)stop {
  [runner cancel];
}

- (void)reset {
  beatCount = 0;
  [self removeAllPlayheads];
}

- (void)clear {
  [hexes makeObjectsPerformSelector:@selector(removeAllTools)];
}

- (void)addPlayhead:(ELPlayhead *)_playhead_ {
  [playheads addObject:_playhead_];
}

- (void)removeAllPlayheads {
  for( ELPlayhead *playhead in playheads ) {
    [playhead setPosition:nil];
  }
  [playheads removeAllObjects];
}

- (void)addGenerator:(ELStartTool *)_generator_ {
  [generators addObject:_generator_];
}

- (void)removeGenerator:(ELStartTool *)_generator_ {
  [generators removeObject:_generator_];
}

- (void)pulse {
  for( ELStartTool *generator in generators ) {
    if( [generator shouldPulseOnBeat:beatCount] ) {
      [generator run:nil];
    }
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
      
      BOOL evenCol = ( col % 2 == 0 );
      BOOL oddCol = !evenCol;
      
      BOOL firstRow = ( row == 0 );
      BOOL lastRow = ( row == HTABLE_MAX_ROW );
      
      BOOL firstCol = ( col == 0 );
      BOOL lastCol = ( col == HTABLE_MAX_COL );
      
      ELHex *hex = [self hexAtColumn:col row:row];
      
      // North
      if( !lastRow ) {
        [hex connectNeighbour:[self hexAtColumn:col row:row+1] direction:N];
      }
      
      // North East
      if( evenCol && !lastCol ) {
        [hex connectNeighbour:[self hexAtColumn:col+1 row:row] direction:NE];
      } else if( oddCol && !lastRow ) {
        [hex connectNeighbour:[self hexAtColumn:col+1 row:row+1] direction:NE];
      }
      
      // South East
      if( evenCol && !lastCol && !firstRow ) {
        [hex connectNeighbour:[self hexAtColumn:col+1 row:row-1] direction:SE];
      } else if( oddCol ) {
        [hex connectNeighbour:[self hexAtColumn:col+1 row:row] direction:SE];
      }
      
      // South Hex
      if( !firstRow ) {
        [hex connectNeighbour:[self hexAtColumn:col row:row-1] direction:S];
      }
      
      // South West
      if( evenCol && !firstCol && !firstRow ) {
        [hex connectNeighbour:[self hexAtColumn:col-1 row:row-1] direction:SW];
      } else if( oddCol ) {
        [hex connectNeighbour:[self hexAtColumn:col-1 row:row] direction:SW];
      }
      
      // North West
      if( evenCol && !firstCol ) {
        [hex connectNeighbour:[self hexAtColumn:col-1 row:row] direction:NW];
      } else if( oddCol && !lastRow ) {
        [hex connectNeighbour:[self hexAtColumn:col-1 row:row+1] direction:NW];
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

- (void)hexCellSelected:(LMHexCell *)_cell_ {
  NSLog( @"Selected hex: %@", _cell_ );
  
  // for( int direction = N; direction <= NW; direction++ ) {
  //   NSLog( @" %d: %@", direction, [(ELHex*)_cell neighbour:direction] );
  // }
  
  if( _cell_ ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:_cell_];
    [player playNote:[(ELHex*)_cell_ note] channel:[channelKnob value] velocity:[velocityKnob value] duration:[durationKnob value]];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:self];
  }
}

- (ELHex *)hexAtColumn:(int)_col row:(int)_row {
  return (ELHex *)[self hexCellAtColumn:_col row:_row];
}

- (LMHexCell *)hexCellAtColumn:(int)_col_ row:(int)_row_ {
  NSAssert4( COL_ROW_OFFSET( _col_, _row_ ) < HTABLE_SIZE, @"Offset %d (%d,%d) is of bounds (%d)!", COL_ROW_OFFSET(_col_,_row_), _col_, _row_, HTABLE_SIZE );
  
  LMHexCell *cell = [hexes objectAtIndex:COL_ROW_OFFSET(_col_,_row_)];
  NSAssert2( cell != nil, @"Requested nil hex at %d,%d", _col_, _row_ );
  return cell;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *layerElement = [NSXMLNode elementWithName:@"layer"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:layerId forKey:@"id"];
  [layerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[enabledKnob xmlRepresentation]];
  [controlsElement addChild:[channelKnob xmlRepresentation]];
  [controlsElement addChild:[tempoKnob xmlRepresentation]];
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [layerElement addChild:controlsElement];
  
  NSXMLElement *cellsElement = [NSXMLNode elementWithName:@"cells"];
  
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELHex *hex = [self hexAtColumn:col row:row];
      
      if( [hex shouldBeSaved] ) {
        [cellsElement addChild:[hex xmlRepresentation]];
      }
    }
  }
  
  [layerElement addChild:cellsElement];
  
  return layerElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ {
  return nil;
}

// Implementing the ELData Protocol
// 
// - (NSXMLElement *)asXMLData {
//   NSXMLElement *layerElement = [NSXMLNode elementWithName:@"layer"];
//   
//   NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
//   // [attributes setObject:[config stringForKey:@"channel"] forKey:@"channel"];
//   // [attributes setObject:[config stringForKey:@"layerId"] forKey:@"id"];
//   
//   // if( [config definesValueForKey:@"pulseCount"] ) {
//   //   [attributes setObject:[config stringForKey:@"pulseCount"] forKey:@"pulseCount"];
//   // }
//   // if( [config definesValueForKey:@"velocity"] ) {
//   //   [attributes setObject:[config stringForKey:@"velocity"] forKey:@"velocity"];
//   // }
//   // if( [config definesValueForKey:@"duration"] ) {
//   //   [attributes setObject:[config stringForKey:@"duration"] forKey:@"duration"];
//   // }
//   // if( [config definesValueForKey:@"bpm"] ) {
//   //   [attributes setObject:[config stringForKey:@"bpm"] forKey:@"bpm"];
//   // }
//   // if( [config definesValueForKey:@"ttl"] ) {
//   //   [attributes setObject:[config stringForKey:@"ttl"] forKey:@"ttl"];
//   // }
//   [layerElement setAttributesAsDictionary:attributes];
//   
//   for( int col = 0; col < HTABLE_COLS; col++ ) {
//     for( int row = 0; row < HTABLE_ROWS; row++ ) {
//       ELHex *hex = [self hexAtColumn:col row:row];
//       
//       if( [[hex tools] count] > 0 ) {
//         [layerElement addChild:[hex asXMLData]];
//       }
//     }
//   }
//   
//   return layerElement;
// }
// 
// - (BOOL)fromXMLData:(NSXMLElement *)_xml_ {
//   
//   NSXMLNode *node;
//   
//   // if( ( node = [_xml_ attributeForName:@"id"] ) ) {
//   //   [config setString:[node stringValue] forKey:@"layerId"];
//   // }
//   // if( ( node = [_xml_ attributeForName:@"pulseCount"] ) ) {
//   //   [config setInteger:[[node stringValue] intValue] forKey:@"pulseCount"];
//   // }
//   // if( ( node = [_xml_ attributeForName:@"velocity"] ) ) {
//   //   [config setInteger:[[node stringValue] intValue] forKey:@"velocity"];
//   // }
//   // if( ( node = [_xml_ attributeForName:@"duration"] ) ) {
//   //   [config setInteger:[[node stringValue] floatValue] forKey:@"duration"];
//   // }
//   // if( ( node = [_xml_ attributeForName:@"bpm"] ) ) {
//   //   [config setInteger:[[node stringValue] intValue] forKey:@"bpm"];
//   // }
//   // if( ( node = [_xml_ attributeForName:@"ttl"] ) ) {
//   //   [config setInteger:[[node stringValue] intValue] forKey:@"ttl"];
//   // }
//   
//   for( NSXMLNode *cellNode in [_xml_ nodesForXPath:@"cell" error:nil] ) {
//     NSXMLElement *cellElement = (NSXMLElement *)cellNode;
//     
//     if( !( node = [cellElement attributeForName:@"col"] ) ) {
//       NSLog( @"Found cell with no column!" );
//       return NO;
//     }
//     int col = [[node stringValue] intValue];
//     
//     if( !( node = [cellElement attributeForName:@"row"] ) ) {
//       NSLog( @"Found cell with no row!" );
//       return NO;
//     }
//     int row = [[node stringValue] intValue];
//     
//     ELHex *hex = [self hexAtColumn:col row:row];
//     if( !hex ) {
//       NSLog( @"Cell reference %d,%d is invalid", col, row );
//       return NO;
//     }
//     
//     if( ![hex fromXMLData:cellElement] ) {
//       NSLog( @"Problem loading cell %d,%d", col, row );
//       return NO;
//     }
//   }
//   
//   return YES;
// }

// Drawing notification from the hex

- (void)needsDisplay {
  // NSLog( @"layer%@#needsDisplay", self );
  if( [delegate respondsToSelector:@selector(setNeedsDisplay:)] ) {
    [delegate setNeedsDisplay:YES];
  }
}

@end
