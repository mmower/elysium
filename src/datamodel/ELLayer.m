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
#import "ELGenerateTool.h"
#import "ELHarmonicTable.h"

#import "RubyBlock.h"

NSPredicate *deadPlayheadFilter;

@implementation ELLayer

+ (NSPredicate *)deadPlayheadFilter {
  if( !deadPlayheadFilter ) {
    deadPlayheadFilter = [NSPredicate predicateWithFormat:@"isDead != TRUE"];
  }
  
  return deadPlayheadFilter;
}

- (id)init {
  if( ( self = [super init] ) ) {
    hexes       = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    playheads   = [[NSMutableArray alloc] init];
    generators  = [[NSMutableArray alloc] init];
    beatCount   = 0;
    timeBase    = 0;
    isRunning   = 0;
    selectedHex = nil;
    
    scripts     = [NSMutableDictionary dictionary];
    
    enabledKnob = [[ELBooleanKnob alloc] initWithName:@"enabled" booleanValue:YES];
    channelKnob = [[ELIntegerKnob alloc] initWithName:@"channel"];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    player = _player_;
    
    tempoKnob      = [[ELIntegerKnob alloc] initWithName:@"tempo" linkedTo:[player tempoKnob]];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" linkedTo:[player timeToLiveKnob]];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" linkedTo:[player pulseCountKnob]];
    velocityKnob   = [[ELIntegerKnob alloc] initWithName:@"velocity" linkedTo:[player velocityKnob]];
    durationKnob   = [[ELFloatKnob alloc] initWithName:@"duration" linkedTo:[player durationKnob]];
    transposeKnob = [[ELIntegerKnob alloc] initWithName:@"transpose" linkedTo:[player transposeKnob]];
    
    [self configureHexes];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ channel:(int)_channel_ {
  if( ( self = [self initWithPlayer:_player_] ) ) {
    [channelKnob setValue:_channel_];
  }
  
  return self;
}

@synthesize player;
@synthesize delegate;
@synthesize layerId;
@synthesize selectedHex;
@synthesize beatCount;

@synthesize enabledKnob;
@synthesize channelKnob;
@synthesize tempoKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize durationKnob;
@synthesize transposeKnob;

@synthesize scripts;

- (void)playNote:(ELNote *)_note_ velocity:(int)_velocity_ duration:(float)_duration_ {
  // UInt64 noteOnTime = timeBase + (beatCount * [self timerResolution]);
  // UInt64 noteOffTime = noteOnTime + ( _duration_ * 1000000 );
  // [player scheduleNote:_note_ channel:[self channel] velocity:[self velocity] on:noteOnTime off:noteOffTime];
  [player playNote:([_note_ number] + [transposeKnob filteredValue]) channel:[channelKnob value] velocity:_velocity_ duration:_duration_];
}

- (void)playNotes:(NSArray *)_notes_ velocity:(int)_velocity_ duration:(float)_duration_ {
  for( ELNote *note in _notes_ ) {
    [player playNote:([note number] + [transposeKnob filteredValue]) channel:[channelKnob value] velocity:_velocity_ duration:_duration_];
  }
}

- (int)timerResolution {
  return 60000000 / [tempoKnob filteredValue];
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
      if( ![playhead isDead] ) {
        [[playhead position] run:playhead];
      }
      
      // ELHex *hex = [playhead position];
      // for( ELTool *tool in [hex toolsExceptType:@"generate"] ) {
      //   if( ![playhead isDead] ) {
      //     [tool run:playhead];
      //   }
      // }
      
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
    UInt64 start = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
    
    [self performSelectorOnMainThread:@selector(runWillRunScript) withObject:nil waitUntilDone:YES];
    [self run];
    [self performSelectorOnMainThread:@selector(runDidRunScript) withObject:nil waitUntilDone:YES];
    
    int elapsed = (AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) - start) / 1000;
    int delay = [self timerResolution] - elapsed;
    if( delay < 1 ) {
      delay = 1;
    }
    
    // NSLog( @"Elapsed usec = %d", elapsed );
    // NSLog( @"Delay usec   = %d", delay );
    // NSLog( @"----" );
    
    usleep( delay );
  }
  
  isRunning = NO;
  [self reset];
}

- (void)runWillRunScript {
  [[scripts objectForKey:@"willRun"] evalWithArg:self];
}

- (void)runDidRunScript {
  [[scripts objectForKey:@"didRun"] evalWithArg:self];
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

- (void)addGenerator:(ELGenerateTool *)_generator_ {
  [generators addObject:_generator_];
}

- (void)removeGenerator:(ELGenerateTool *)_generator_ {
  [generators removeObject:_generator_];
}

- (void)pulse {
  for( ELGenerateTool *generator in generators ) {
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
  ELHex *hex = (ELHex *)_cell_;
  
  [self setSelectedHex:hex];
  
  // NSLog( @"Selected hex: %@", _cell_ );
  
  if( hex ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:hex];
    [player playNote:[[hex note] number] channel:[channelKnob value] velocity:[velocityKnob filteredValue] duration:[durationKnob filteredValue]];
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
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[transposeKnob xmlRepresentation]];
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
  
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  for( NSString *name in [scripts allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
    
    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
    [cdataNode setStringValue:[scripts objectForKey:name]];
    [scriptElement addChild:cdataNode];
    [scriptsElement addChild:scriptElement];
  }
  [layerElement addChild:scriptsElement];
  
  return layerElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithPlayer:_parent_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"id"];
    if( attributeNode ) {
      [self setLayerId:[attributeNode stringValue]];
    } else {
      NSLog( @"Found layer without id, cannot load it!" );
      return nil;
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='enabled']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    enabledKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='channel']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    channelKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    tempoKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ tempoKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ timeToLiveKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ pulseCountKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ velocityKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[_parent_ durationKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='transpose']" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    transposeKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ transposeKnob] player:_player_];
    
    nodes = [_representation_ nodesForXPath:@"cells/cell" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      NSXMLNode *attributeNode;
      
      attributeNode = [element attributeForName:@"col"];
      int col = [[attributeNode stringValue] intValue];
      
      attributeNode = [element attributeForName:@"row"];
      int row = [[attributeNode stringValue] intValue];
      
      ELHex *hex = [self hexAtColumn:col row:row];
      [hex initWithXmlRepresentation:element parent:self player:_player_];
    }
    
    // Scripts
    nodes = [_representation_ nodesForXPath:@"scripts/script" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [scripts setObject:[[element stringValue] asRubyBlock]
                  forKey:[[element attributeForName:@"name"] stringValue]];
    }
  }
  
  return self;
}

// Drawing notification from the hex

- (void)needsDisplay {
  // NSLog( @"layer%@#needsDisplay", self );
  if( [delegate respondsToSelector:@selector(setNeedsDisplay:)] ) {
    [delegate setNeedsDisplay:YES];
  }
}

@end
