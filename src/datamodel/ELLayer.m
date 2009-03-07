//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELHex.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

#import "ELKey.h"
#import "ELNote.h"
#import "ELHarmonicTable.h"

#import "ELToken.h"
#import "ELGenerateToken.h"

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
    
    enabledDial   = [[ELDial alloc] initWithName:@"enabled"
                                         toolTip:@"Controls whether this layer should play or not."
                                             tag:0
                                       boolValue:YES];
    
    channelDial   = [[ELDial alloc] initWithMode:dialFree
                                            name:@"channel"
                                         toolTip:@"The MIDI channel this layer will, by default, send notes on."
                                             tag:0
                                          parent:nil
                                      oscillator:nil
                                        assigned:0
                                            last:0
                                           value:0
                                             min:1
                                             max:16
                                            step:1];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)thePlayer {
  if( ( self = [self init] ) ) {
    [self setPlayer:thePlayer];
    
    [self setTempoDial:[[ELDial alloc] initWithParent:[player tempoDial]]];
    [self setBarLengthDial:[[ELDial alloc] initWithParent:[player barLengthDial]]];
    [self setTimeToLiveDial:[[ELDial alloc] initWithParent:[player timeToLiveDial]]];
    [self setPulseEveryDial:[[ELDial alloc] initWithParent:[player pulseEveryDial]]];
    [self setVelocityDial:[[ELDial alloc] initWithParent:[player velocityDial]]];
    [self setEmphasisDial:[[ELDial alloc] initWithParent:[player emphasisDial]]];
    [self setTempoSyncDial:[[ELDial alloc] initWithParent:[player tempoSyncDial]]];
    [self setNoteLengthDial:[[ELDial alloc] initWithParent:[player noteLengthDial]]];
    [self setTransposeDial:[[ELDial alloc] initWithParent:[player transposeDial]]];
    
    [self configureHexes];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)_player_ channel:(int)_channel_ {
  if( ( self = [self initWithPlayer:_player_] ) ) {
    [channelDial setValue:_channel_];
  }
  
  return self;
}

@synthesize player;
@synthesize delegate;
@synthesize layerId;
@synthesize selectedHex;
@synthesize beatCount;
@synthesize key;

@dynamic enabledDial;

- (ELDial *)enabledDial {
  return enabledDial;
}

- (void)setEnabledDial:(ELDial *)newEnabledDial {
  enabledDial = newEnabledDial;
  [enabledDial setDelegate:self];
}

@dynamic channelDial;

- (ELDial *)channelDial {
  return channelDial;
}

- (void)setChannelDial:(ELDial *)newChannelDial {
  channelDial = newChannelDial;
  [channelDial setDelegate:self];
}

@dynamic tempoDial;

- (ELDial *)tempoDial {
  return tempoDial;
}

- (void)setTempoDial:(ELDial *)newTempoDial {
  tempoDial = newTempoDial;
  [tempoDial setDelegate:self];
}

@dynamic barLengthDial;

- (ELDial *)barLengthDial {
  return barLengthDial;
}

- (void)setBarLengthDial:(ELDial *)newBarLengthDial {
  barLengthDial = newBarLengthDial;
  [barLengthDial setDelegate:self];
}

@dynamic timeToLiveDial;

- (ELDial *)timeToLiveDial {
  return timeToLiveDial;
}

- (void)setTimeToLiveDial:(ELDial *)newTimeToLiveDial {
  timeToLiveDial = newTimeToLiveDial;
  [timeToLiveDial setDelegate:self];
}

@dynamic pulseEveryDial;

- (ELDial *)pulseEveryDial {
  return pulseEveryDial;
}

- (void)setPulseEveryDial:(ELDial *)newPulseEveryDial {
  pulseEveryDial = newPulseEveryDial;
  [pulseEveryDial setDelegate:self];
}

@dynamic velocityDial;

- (ELDial *)velocityDial {
  return velocityDial;
}

- (void)setVelocityDial:(ELDial *)newVelocityDial {
  velocityDial = newVelocityDial;
  [velocityDial setDelegate:self];
}

@dynamic emphasisDial;

- (ELDial *)emphasisDial {
  return emphasisDial;
}

- (void)setEmphasisDial:(ELDial *)newEmphasisDial {
  emphasisDial = newEmphasisDial;
  [emphasisDial setDelegate:self];
}

@dynamic tempoSyncDial;

- (ELDial *)tempoSyncDial {
  return tempoSyncDial;
}

- (void)setTempoSyncDial:(ELDial *)newTempoSyncDial {
  tempoSyncDial = newTempoSyncDial;
  [tempoSyncDial setDelegate:self];
}

@dynamic noteLengthDial;

- (ELDial *)noteLengthDial {
  return noteLengthDial;
}

- (void)setNoteLengthDial:(ELDial *)newNoteLengthDial {
  noteLengthDial = newNoteLengthDial;
  [noteLengthDial setDelegate:self];
}

@dynamic transposeDial;

- (ELDial *)transposeDial {
  return transposeDial;
}

- (void)setTransposeDial:(ELDial *)newTransposeDial {
  transposeDial = newTransposeDial;
  [transposeDial setDelegate:self];
}

- (void)dialDidUnsetOscillator:(ELDial *)dial {
  [player dialDidUnsetOscillator:dial];
}

- (void)dialDidSetOscillator:(ELDial *)dial {
  [player dialDidSetOscillator:dial];
}

@synthesize scripts;
@synthesize scriptingTag = layerId;

- (int)timerResolution {
  int tempo = [tempoDial value];
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
  return ( beatCount % [barLengthDial value] ) == 0;
  // return (beatCount % [barLengthKnob dynamicValue]) == 0;
}

- (void)run {
  if( [enabledDial boolValue] ) {
    // Advance existing playheads, offer dead playheads a chance to clean up
    for( ELPlayhead *playhead in playheads ) {
      [playhead advance];
      [playhead cleanup];
    }
    
    // Remove dead playheads
    [playheads filterUsingPredicate:[ELLayer deadPlayheadFilter]];
    
    // Generate any new playheads for this beat
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
  double priority = [[NSUserDefaults standardUserDefaults] floatForKey:ELLayerThreadPriorityKey];
  BOOL prioritySet = [NSThread setThreadPriority:priority];
  NSLog( @"Set priority to %f: %@", priority, prioritySet ? @"YES" : @"NO" );
  
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

- (ELScript *)callbackTemplate {
  return [@"function(player,layer) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
}

- (void)start {
  // Tell all the cells we're starting
  [hexes makeObjectsPerformSelector:@selector(start)];
  
  runner = [[NSThread alloc] initWithTarget:self selector:@selector(runLayer) object:nil];
  [runner start];
}

- (void)stop {
  [hexes makeObjectsPerformSelector:@selector(stop)];
  [runner cancel];
}

- (void)reset {
  beatCount = 0;
  [self removeAllPlayheads];
  [self needsDisplay];
}

- (void)clear {
  [hexes makeObjectsPerformSelector:@selector(removeAllTokens)];
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

- (void)addGenerator:(ELGenerateToken *)_generator_ {
  [generators addObject:_generator_];
}

- (void)removeGenerator:(ELGenerateToken *)_generator_ {
  [generators removeObject:_generator_];
}

- (void)pulse {
  for( ELGenerateToken *generator in generators ) {
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
      // [durationKnob dynamicValue]
      [[hex note] playOnChannel:[channelDial value] duration:2.0 velocity:[velocityDial value] transpose:0];
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
  [controlsElement addChild:[enabledDial xmlRepresentation]];
  [controlsElement addChild:[channelDial xmlRepresentation]];
  [controlsElement addChild:[tempoDial xmlRepresentation]];
  [controlsElement addChild:[barLengthDial xmlRepresentation]];
  [controlsElement addChild:[timeToLiveDial xmlRepresentation]];
  [controlsElement addChild:[pulseEveryDial xmlRepresentation]];
  [controlsElement addChild:[velocityDial xmlRepresentation]];
  [controlsElement addChild:[emphasisDial xmlRepresentation]];
  [controlsElement addChild:[tempoSyncDial xmlRepresentation]];
  [controlsElement addChild:[noteLengthDial xmlRepresentation]];
  [controlsElement addChild:[transposeDial xmlRepresentation]];
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
    
    [self setEnabledDial:[_representation_ loadDial:@"enabled" parent:nil player:_player_ error:_error_]];
    [self setChannelDial:[_representation_ loadDial:@"channel" parent:nil player:_player_ error:_error_]];
    [self setTempoDial:[_representation_ loadDial:@"tempo" parent:nil player:_player_ error:_error_]];
    [self setBarLengthDial:[_representation_ loadDial:@"barLength" parent:nil player:_player_ error:_error_]];
    [self setTimeToLiveDial:[_representation_ loadDial:@"timeToLive" parent:nil player:_player_ error:_error_]];
    [self setPulseEveryDial:[_representation_ loadDial:@"pulseEvery" parent:nil player:_player_ error:_error_]];
    [self setVelocityDial:[_representation_ loadDial:@"velocity" parent:nil player:_player_ error:_error_]];
    [self setEmphasisDial:[_representation_ loadDial:@"emphasis" parent:nil player:_player_ error:_error_]];
    [self setTempoSyncDial:[_representation_ loadDial:@"tempoSync" parent:nil player:_player_ error:_error_]];
    [self setNoteLengthDial:[_representation_ loadDial:@"noteLength" parent:nil player:_player_ error:_error_]];
    [self setTransposeDial:[_representation_ loadDial:@"transpose" parent:nil player:_player_ error:_error_]];
    
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
  if( [delegate respondsToSelector:@selector(setNeedsDisplay:)] ) {
    [delegate setNeedsDisplay:YES];
  }
}

@end
