//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELLayer.h"

#import "ELHex.h"
#import "ELKey.h"
#import "ELNote.h"
#import "ELTool.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"
#import "ELGenerateTool.h"
#import "ELHarmonicTable.h"

NSPredicate *deadPlayheadFilter;

@implementation ELLayer

+ (void)initialize {
  deadPlayheadFilter = [NSPredicate predicateWithFormat:@"isDead != TRUE"];
}

+ (NSPredicate *)deadPlayheadFilter {
  return deadPlayheadFilter;
}

- (id)init {
  if( ( self = [super init] ) ) {
    hexes         = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    playheads     = [[NSMutableArray alloc] init];
    playheadQueue = [[NSMutableArray alloc] init];
    generators    = [[NSMutableArray alloc] init];
    beatCount     = 0;
    timeBase      = 0;
    isRunning     = 0;
    selectedHex   = nil;
    
    scripts       = [NSMutableDictionary dictionary];
    
    key           = [ELKey noKey];
    
    [self addObserver:self forKeyPath:@"key" options:0 context:nil];
    
    enabledKnob   = [[ELBooleanKnob alloc] initWithName:@"enabled" booleanValue:YES];
    channelKnob   = [[ELIntegerKnob alloc] initWithName:@"channel"];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    player = _player_;
    
    tempoKnob      = [[ELIntegerKnob alloc] initWithName:@"tempo" linkedToIntegerKnob:[player tempoKnob]];
    barLengthKnob  = [[ELIntegerKnob alloc] initWithName:@"barLength" linkedToIntegerKnob:[player barLengthKnob]];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" linkedToIntegerKnob:[player timeToLiveKnob]];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" linkedToIntegerKnob:[player pulseCountKnob]];
    velocityKnob   = [[ELIntegerKnob alloc] initWithName:@"velocity" linkedToIntegerKnob:[player velocityKnob]];
    emphasisKnob   = [[ELIntegerKnob alloc] initWithName:@"emphasis" linkedToIntegerKnob:[player emphasisKnob]];
    durationKnob   = [[ELFloatKnob alloc] initWithName:@"duration" linkedToFloatKnob:[player durationKnob]];
    transposeKnob  = [[ELIntegerKnob alloc] initWithName:@"transpose" linkedToIntegerKnob:[player transposeKnob]];
    
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
@synthesize key;

@synthesize enabledKnob;
@synthesize channelKnob;
@synthesize tempoKnob;
@synthesize barLengthKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize emphasisKnob;
@synthesize durationKnob;
@synthesize transposeKnob;

@synthesize scripts;
@synthesize scriptingTag = layerId;

- (int)timerResolution {
  int tempo = [tempoKnob dynamicValue];
  if( tempo < 1 ) {
    tempo = 1;
  }
  
  return 60000000 / tempo;
}

- (void)observeValueForKeyPath:(NSString *)_keyPath_ ofObject:(id)_object_ change:(NSDictionary *)_change_ context:(void *)_context_ {
  if( [_keyPath_ isEqualToString:@"key"] ) {
    [self needsDisplay];
  }
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

- (BOOL)firstBeatInBar {
  return (beatCount % [barLengthKnob dynamicValue]) == 0;
}

- (void)run {
  if( [enabledKnob value] ) {
    // Advance existing playheads, offer dead playheads a chance to clean up
    for( ELPlayhead *playhead in playheads ) {
      [playhead advance];
      [playhead cleanup];
    }
    
    // Remove dead playheads
    [playheads filterUsingPredicate:[ELLayer deadPlayheadFilter]];
    
    // On the first and every pulseCount beats, generate new playheads
    [self pulse];
    
    // Run all current playheads
    for( ELPlayhead *playhead in playheads ) {
      [[playhead position] run:playhead];
    }
    
    [self addQueuedPlayheads];
    
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
    
    if( delay < 25 ) {
      NSLog( @"Warning: timer resolution %d is less than safe margin. Clock drift will result.", delay );
    }
    
    usleep( delay );
  }
  
  isRunning = NO;
  [self reset];
}

- (void)runWillRunScript {
  [[scripts objectForKey:@"willRun"] evalWithArg:player arg:self];
}

- (void)runDidRunScript {
  [[scripts objectForKey:@"didRun"] evalWithArg:player arg:self];
}

- (void)start {
  // Tell all the cells we're starting
  [hexes makeObjectsPerformSelector:@selector(start)];
  
  runner = [[NSThread alloc] initWithTarget:self selector:@selector(runLayer) object:nil];
  [runner start];
}

- (void)stop {
  [runner cancel];
}

- (void)reset {
  beatCount = 0;
  [self removeAllPlayheads];
  [self needsDisplay];
}

- (void)clear {
  [hexes makeObjectsPerformSelector:@selector(removeAllTools)];
}

- (void)queuePlayhead:(ELPlayhead *)_playhead_ {
  [playheadQueue addObject:_playhead_];
}

- (void)addQueuedPlayheads {
  if( [playheadQueue count] > 0 ) {
    for( ELPlayhead *playhead in playheadQueue ) {
      [self addPlayhead:playhead];
    }
    [playheadQueue removeAllObjects];
  }
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
  [player setSelectedLayer:self];
  if( hex ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:hex];
    
    if( ![player performanceMode] ) {
      [[hex note] playOnChannel:[channelKnob value] duration:[durationKnob dynamicValue] velocity:[velocityKnob dynamicValue] transpose:0];
    }
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
  if( key ) {
    [attributes setObject:[key name] forKey:@"key"];
  }
  [layerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[enabledKnob xmlRepresentation]];
  [controlsElement addChild:[channelKnob xmlRepresentation]];
  [controlsElement addChild:[tempoKnob xmlRepresentation]];
  [controlsElement addChild:[barLengthKnob xmlRepresentation]];
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[emphasisKnob xmlRepresentation]];
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

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self initWithPlayer:_parent_] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    NSString *idAttribute = [_representation_ attributeAsString:@"id"];
    if( idAttribute == nil ) {
      *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain
                                             code:EL_ERR_LAYER_MISSING_ID
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Layer found without an ID attribute", NSLocalizedDescriptionKey, nil]];
      return nil;
    } else {
      [self setLayerId:idAttribute];
    }
    
    NSString *keyAttribute = [_representation_ attributeAsString:@"key"];
    if( keyAttribute ) {
      [self setKey:[ELKey keyNamed:keyAttribute]];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='enabled']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        enabledKnob = [[ELBooleanKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        enabledKnob = [[ELBooleanKnob alloc] initWithName:@"enabled" booleanValue:YES];
      }
      
      if( enabledKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='channel']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        channelKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:_player_ error:_error_];
      } else {
        channelKnob = [[ELIntegerKnob alloc] initWithName:@"channel" integerValue:1 minimum:1 maximum:16 stepping:1];
      }
      
      if( channelKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        tempoKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ tempoKnob] player:_player_ error:_error_];
      } else {
        tempoKnob = [[ELIntegerKnob alloc] initWithName:@"tempo" linkedToIntegerKnob:[_player_ tempoKnob]];
      }
      
      if( tempoKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='barLength']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        barLengthKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ barLengthKnob] player:_player_ error:_error_];
      } else {
        barLengthKnob = [[ELIntegerKnob alloc] initWithName:@"barLength" linkedToIntegerKnob:[_player_ barLengthKnob]];
      }
      
      if( barLengthKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ timeToLiveKnob] player:_player_ error:_error_];
      } else {
        timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" linkedToIntegerKnob:[_player_ timeToLiveKnob]];
      }
      
      if( timeToLiveKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ pulseCountKnob] player:_player_ error:_error_];
      } else {
        pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" linkedToIntegerKnob:[_player_ pulseCountKnob]];
      }
      
      if( pulseCountKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ velocityKnob] player:_player_ error:_error_];
      } else {
        velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity" linkedToIntegerKnob:[_player_ velocityKnob]];
      }
      
      if( velocityKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='emphasis']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        emphasisKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ emphasisKnob] player:_player_ error:_error_];
      } else {
        emphasisKnob = [[ELIntegerKnob alloc] initWithName:@"emphasis" linkedToIntegerKnob:[_player_ emphasisKnob]];
      }
      
      if( emphasisKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:[_parent_ durationKnob] player:_player_ error:_error_];
      } else {
        durationKnob = [[ELFloatKnob alloc] initWithName:@"duration" linkedToFloatKnob:[_player_ durationKnob]];
      }
      
      if( durationKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='transpose']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      if( ( element = [nodes firstXMLElement] ) ) {
        transposeKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:[_parent_ transposeKnob] player:_player_ error:_error_];
      } else {
        transposeKnob = [[ELIntegerKnob alloc] initWithName:@"transpose" linkedToIntegerKnob:[_player_ transposeKnob]];
      }
      
      if( transposeKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"cells/cell" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        NSXMLElement *element = (NSXMLElement *)node;
        NSXMLNode *attributeNode;

        attributeNode = [element attributeForName:@"col"];
        if( attributeNode == nil ) {
          *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_LAYER_CELL_REF_INVALID userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cell has no or invalid column reference",NSLocalizedDescriptionKey,nil]];
          return nil;
        }
        int col = [[attributeNode stringValue] intValue];

        attributeNode = [element attributeForName:@"row"];
        if( attributeNode == nil ) {
          *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_LAYER_CELL_REF_INVALID userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cell has no or invalid row reference",NSLocalizedDescriptionKey,nil]];
          return nil;
        }
        int row = [[attributeNode stringValue] intValue];

        ELHex *hex = [[self hexAtColumn:col row:row] initWithXmlRepresentation:element parent:self player:_player_ error:_error_];
        if( hex == nil ) {
          return nil;
        }
      }
    }
    
    // Scripts
    nodes = [_representation_ nodesForXPath:@"scripts/script" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        NSXMLElement *element = (NSXMLElement *)node;
        [scripts setObject:[[element stringValue] asJavascriptFunction]
                    forKey:[[element attributeForName:@"name"] stringValue]];
      }
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
