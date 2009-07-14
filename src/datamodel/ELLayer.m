//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELCell.h"
#import "ELLayer.h"
#import "ELPlayer.h"
#import "ELPlayhead.h"

#import "ELKey.h"
#import "ELNote.h"
#import "ELHarmonicTable.h"

#import "ELToken.h"
#import "ELGenerateToken.h"
#import "ELMIDINoteMessage.h"

#import "ElysiumController.h"

NSPredicate *deadPlayheadFilter;

@implementation ELLayer

#pragma mark Class methods

+ (void)initialize {
  deadPlayheadFilter = [NSPredicate predicateWithFormat:@"isDead != TRUE"];
}


+ (NSPredicate *)deadPlayheadFilter {
  return deadPlayheadFilter;
}


#pragma mark Initializers


- (id)init {
  if( ( self = [super init] ) ) {
    _cells         = [[NSMutableArray alloc] initWithCapacity:HTABLE_SIZE];
    _playheads     = [[NSMutableArray alloc] init];
    _playheadQueue = [[NSMutableArray alloc] init];
    _generators    = [[NSMutableArray alloc] init];
    _beatCount     = 0;
    _timeBase      = 0;
    _isRunning     = NO;
    _selectedCell  = nil;
    _receivedNotes = [[NSMutableArray alloc] init];
    _scripts       = [NSMutableDictionary dictionary];
    _key           = [ELKey noKey];
    
    [self addObserver:self forKeyPath:@"key" options:0 context:nil];
    
    _enabledDial   = [[ELDial alloc] initWithName:@"enabled"
                                          toolTip:@"Controls whether this layer should play or not."
                                              tag:0
                                        boolValue:YES];
    
    _channelDial   = [[ELDial alloc] initWithMode:dialFree
                                             name:@"channel"
                                          toolTip:@"The MIDI channel this layer will, by default, send notes on."
                                              tag:0
                                           player:[self player]
                                           parent:nil
                                       oscillator:nil
                                         assigned:1
                                             last:1
                                            value:1
                                              min:1
                                              max:16
                                             step:1];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)player {
  if( ( self = [self init] ) ) {
    [self setPlayer:player];
    
    [self setTempoDial:[[ELDial alloc] initWithParent:[[self player] tempoDial]]];
    [self setBarLengthDial:[[ELDial alloc] initWithParent:[[self player] barLengthDial]]];
    [self setTimeToLiveDial:[[ELDial alloc] initWithParent:[[self player] timeToLiveDial]]];
    [self setPulseEveryDial:[[ELDial alloc] initWithParent:[[self player] pulseEveryDial]]];
    [self setVelocityDial:[[ELDial alloc] initWithParent:[[self player] velocityDial]]];
    [self setEmphasisDial:[[ELDial alloc] initWithParent:[[self player] emphasisDial]]];
    [self setTempoSyncDial:[[ELDial alloc] initWithParent:[[self player] tempoSyncDial]]];
    [self setNoteLengthDial:[[ELDial alloc] initWithParent:[[self player] noteLengthDial]]];
    [self setTransposeDial:[[ELDial alloc] initWithParent:[[self player] transposeDial]]];
    
    [self configureCells];
  }
  
  return self;
}

- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel {
  if( ( self = [self initWithPlayer:player] ) ) {
    [[self channelDial] setValue:channel];
  }
  
  return self;
}


#pragma mark Properties

@synthesize player = _player;
@synthesize delegate = _delegate;
@synthesize layerId = _layerId;
@synthesize selectedCell = _selectedCell;
@synthesize beatCount = _beatCount;
@synthesize key = _key;
@synthesize receivedNotes = _receivedNotes;

@synthesize dirty = _dirty;

- (void)setDirty:(BOOL)dirty {
  _dirty = dirty;
  if( _dirty ) {
    [[self player] setDirty:YES];
  }
}


@synthesize enabledDial = _enabledDial;

- (void)setEnabledDial:(ELDial *)enabledDial {
  _enabledDial = enabledDial;
  [_enabledDial setDelegate:self];
}


@synthesize channelDial = _channelDial;

- (void)setChannelDial:(ELDial *)channelDial {
  _channelDial = channelDial;
  [_channelDial setDelegate:self];
}


@synthesize tempoDial = _tempoDial;

- (void)setTempoDial:(ELDial *)tempoDial {
  _tempoDial = tempoDial;
  [_tempoDial setDelegate:self];
}


@synthesize barLengthDial = _barLengthDial;

- (void)setBarLengthDial:(ELDial *)barLengthDial {
  _barLengthDial = barLengthDial;
  [_barLengthDial setDelegate:self];
}


@synthesize timeToLiveDial = _timeToLiveDial;

- (void)setTimeToLiveDial:(ELDial *)timeToLiveDial {
  _timeToLiveDial = timeToLiveDial;
  [_timeToLiveDial setDelegate:self];
}


@synthesize pulseEveryDial = _pulseEveryDial;

- (void)setPulseEveryDial:(ELDial *)pulseEveryDial {
  _pulseEveryDial = pulseEveryDial;
  [_pulseEveryDial setDelegate:self];
}


@synthesize velocityDial = _velocityDial;

- (void)setVelocityDial:(ELDial *)velocityDial {
  _velocityDial = velocityDial;
  [_velocityDial setDelegate:self];
}


@synthesize emphasisDial = _emphasisDial;

- (void)setEmphasisDial:(ELDial *)emphasisDial {
  _emphasisDial = emphasisDial;
  [_emphasisDial setDelegate:self];
}


@synthesize tempoSyncDial = _tempoSyncDial;

- (void)setTempoSyncDial:(ELDial *)tempoSyncDial {
  _tempoSyncDial = tempoSyncDial;
  [_tempoSyncDial setDelegate:self];
}


@synthesize noteLengthDial = _noteLengthDial;

- (void)setNoteLengthDial:(ELDial *)noteLengthDial {
  _noteLengthDial = noteLengthDial;
  [_noteLengthDial setDelegate:self];
}


@synthesize transposeDial = _transposeDial;

- (void)setTransposeDial:(ELDial *)transposeDial {
  _transposeDial = transposeDial;
  [_transposeDial setDelegate:self];
}


@dynamic visible;

- (BOOL)visible {
  return [[[self delegate] window] isVisible];
}

- (void)setVisible:(BOOL)visible {
  if( visible ) {
    [[[self delegate] window] makeKeyAndOrderFront:self];
  } else {
    /* As a safety measure we only allow this when
     * there is more than one layer. Otherwise the mainwindow
     * disappears, breaking everything.
     */
    if( [[[self player] layers] count] > 1 ) {
      [[[self delegate] window] orderOut:self];
    }
  }
}


@synthesize scripts = _scripts;
@synthesize scriptingTag = _layerId;


#pragma mark Utility methods

- (int)timerResolution {
  int tempo = [[self tempoDial] value];
  if( tempo < 1 ) {
    tempo = 1;
  }
  
  return 60000000 / tempo;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if( [keyPath isEqualToString:@"key"] ) {
    [self needsDisplay];
  }
}


- (BOOL)firstBeatInBar {
  return ( [self beatCount] % [[self barLengthDial] value] ) == 0;
}


#pragma mark Layer manipulation

- (void)run {
  if( [[self enabledDial] boolValue] ) {
    // Advance existing playheads, offer dead playheads a chance to clean up
    for( ELPlayhead *playhead in _playheads ) {
      [playhead advance];
      [playhead cleanup];
    }
    
    // Remove dead playheads
    [_playheads filterUsingPredicate:[ELLayer deadPlayheadFilter]];
    
    // Generate any new playheads for this beat
    [self pulse];
    
    // Run all current playheads
    for( ELPlayhead *playhead in _playheads ) {
      [[playhead position] run:playhead];
    }
    
    [self addQueuedPlayheads];
    
    [[self receivedNotes] removeAllObjects];
    
    [[self delegate] setNeedsDisplay:YES];
  }
  
  // Beat is over
  [self setBeatCount:[self beatCount]+1];
}


- (void)runLayer {
  double priority = [[NSUserDefaults standardUserDefaults] floatForKey:ELLayerThreadPriorityKey];
  BOOL prioritySet = [NSThread setThreadPriority:priority];
  NSLog( @"Set priority to %f: %@", priority, prioritySet ? @"YES" : @"NO" );
  
  _timeBase  = AudioGetCurrentHostTime();
  _isRunning = YES;
  while( ![_runner isCancelled] ) {
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
  
  _isRunning = NO;
  [self reset];
}


- (void)runWillRunScript {
  [[[self scripts] objectForKey:@"willRun"] evalWithArg:[self player] arg:self];
}


- (void)runDidRunScript {
  [[[self scripts] objectForKey:@"didRun"] evalWithArg:[self player] arg:self];
}


- (ELScript *)callbackTemplate {
  return [@"function(player,layer) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
}


- (void)start {
  // Tell all the cells we're starting
  [_cells makeObjectsPerformSelector:@selector(start)];
  
  _runner = [[NSThread alloc] initWithTarget:self selector:@selector(runLayer) object:nil];
  [_runner start];
}


- (void)stop {
  [_cells makeObjectsPerformSelector:@selector(stop)];
  [_runner cancel];
}


- (void)reset {
  [self setBeatCount:0];
  [self removeAllPlayheads];
  [self needsDisplay];
}


- (void)clear {
  [_cells makeObjectsPerformSelector:@selector(removeAllTokens)];
}


- (void)queuePlayhead:(ELPlayhead *)playhead {
  [_playheadQueue addObject:playhead];
}


- (void)addQueuedPlayheads {
  if( [_playheadQueue count] > 0 ) {
    for( ELPlayhead *playhead in _playheadQueue ) {
      [self addPlayhead:playhead];
    }
    [_playheadQueue removeAllObjects];
  }
}


- (void)addPlayhead:(ELPlayhead *)playhead {
  [_playheads addObject:playhead];
}


- (void)removeAllPlayheads {
  for( ELPlayhead *playhead in _playheads ) {
    [playhead setPosition:nil];
  }
  [_playheads removeAllObjects];
}


- (void)addGenerator:(ELGenerateToken *)generator {
  [_generators addObject:generator];
}


- (void)removeGenerator:(ELGenerateToken *)generator {
  [_generators removeObject:generator];
}


- (void)pulse {
  for( ELGenerateToken *generator in _generators ) {
    if( [generator shouldPulseOnBeat:[self beatCount]] ) {
      [generator run:nil];
    }
  }
}


#pragma mark Incoming MIDI support


- (void)handleMIDINoteMessage:(ELMIDINoteMessage *)message {
  if( ( [message channel] + 1 ) == [[self channelDial] value] ) {
    [[self receivedNotes] addObject:message];
  }
}


- (BOOL)receivedMIDINote:(ELNote *)note {
  for( ELMIDINoteMessage *noteMessage in [[self receivedNotes] copy] ) {
    if( [noteMessage noteOn] && [noteMessage note] == [note number] ) {
      return YES;
    }
  }
  
  return NO;
}


- (void)configureCells {
  ELHarmonicTable *harmonicTable = [[self player] harmonicTable];
  NSAssert( harmonicTable != nil, @"Harmonic table should never be nil" );
  
  NSAssert( _cells != nil, @"cells have not been initialized!" );
  
  // First create an array of cells that will form the lattice
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELNote *note = [harmonicTable noteAtCol:col row:row];
      NSAssert( note != nil, @"Note should never be nil" );
      
      ELCell *cell = [[ELCell alloc] initWithLayer:self
                                              note:note
                                            column:col
                                               row:row];
      NSAssert( cell != nil, @"Generated cells should never be nil" );
      
      [_cells addObject:cell];
    }
  }

  // Now connect the cells into the lattice structure
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      
      BOOL evenCol = ( col % 2 == 0 );
      BOOL oddCol = !evenCol;
      
      BOOL firstRow = ( row == 0 );
      BOOL lastRow = ( row == HTABLE_MAX_ROW );
      
      BOOL firstCol = ( col == 0 );
      BOOL lastCol = ( col == HTABLE_MAX_COL );
      
      ELCell *cell = [self cellAtColumn:col row:row];
      
      // North
      if( !lastRow ) {
        [cell connectNeighbour:[self cellAtColumn:col row:row+1] direction:N];
      }
      
      // North East
      if( evenCol && !lastCol ) {
        [cell connectNeighbour:[self cellAtColumn:col+1 row:row] direction:NE];
      } else if( oddCol && !lastRow ) {
        [cell connectNeighbour:[self cellAtColumn:col+1 row:row+1] direction:NE];
      }
      
      // South East
      if( evenCol && !lastCol && !firstRow ) {
        [cell connectNeighbour:[self cellAtColumn:col+1 row:row-1] direction:SE];
      } else if( oddCol ) {
        [cell connectNeighbour:[self cellAtColumn:col+1 row:row] direction:SE];
      }
      
      // South
      if( !firstRow ) {
        [cell connectNeighbour:[self cellAtColumn:col row:row-1] direction:S];
      }
      
      // South West
      if( evenCol && !firstCol && !firstRow ) {
        [cell connectNeighbour:[self cellAtColumn:col-1 row:row-1] direction:SW];
      } else if( oddCol ) {
        [cell connectNeighbour:[self cellAtColumn:col-1 row:row] direction:SW];
      }
      
      // North West
      if( evenCol && !firstCol ) {
        [cell connectNeighbour:[self cellAtColumn:col-1 row:row] direction:NW];
      } else if( oddCol && !lastRow ) {
        [cell connectNeighbour:[self cellAtColumn:col-1 row:row+1] direction:NW];
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


- (void)hexCellSelected:(LMHexCell *)newlySelectedCell {
  ELCell *cell = (ELCell *)newlySelectedCell;
  [self setSelectedCell:cell];
  [[self player] setSelectedLayer:self];
  if( cell ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:cell];
    
    if( ![[NSApp delegate] performanceMode] ) {
      // [durationKnob dynamicValue]
      [[cell note] playOnChannel:[[self channelDial] value] duration:2.0 velocity:[[self velocityDial] value] transpose:0];
    }
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:ELNotifyObjectSelectionDidChange object:self];
  }
}


- (ELCell *)cellAtColumn:(int)col row:(int)row {
  return (ELCell *)[self hexCellAtColumn:col row:row];
}


- (LMHexCell *)hexCellAtColumn:(int)col row:(int)row {
  NSAssert4( COL_ROW_OFFSET( col, row ) < HTABLE_SIZE, @"Offset %d (%d,%d) is of bounds (%d)!", COL_ROW_OFFSET(col,row), col, row, HTABLE_SIZE );
  
  LMHexCell *cell = [_cells objectAtIndex:COL_ROW_OFFSET(col,row)];
  NSAssert2( cell != nil, @"Requested nil cell at %d,%d", col, row );
  return cell;
}


#pragma mark Implements ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *layerElement = [NSXMLNode elementWithName:@"layer"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[self layerId] forKey:@"id"];
  if( [self key] ) {
    [attributes setObject:[[self key] name] forKey:@"key"];
  }
  [layerElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[[self enabledDial] xmlRepresentation]];
  [controlsElement addChild:[[self channelDial] xmlRepresentation]];
  [controlsElement addChild:[[self tempoDial] xmlRepresentation]];
  [controlsElement addChild:[[self barLengthDial] xmlRepresentation]];
  [controlsElement addChild:[[self timeToLiveDial] xmlRepresentation]];
  [controlsElement addChild:[[self pulseEveryDial] xmlRepresentation]];
  [controlsElement addChild:[[self velocityDial] xmlRepresentation]];
  [controlsElement addChild:[[self emphasisDial] xmlRepresentation]];
  [controlsElement addChild:[[self tempoSyncDial] xmlRepresentation]];
  [controlsElement addChild:[[self noteLengthDial] xmlRepresentation]];
  [controlsElement addChild:[[self transposeDial] xmlRepresentation]];
  [layerElement addChild:controlsElement];
  
  NSXMLElement *cellsElement = [NSXMLNode elementWithName:@"cells"];
  
  for( int col = 0; col < HTABLE_COLS; col++ ) {
    for( int row = 0; row < HTABLE_ROWS; row++ ) {
      ELCell *cell = [self cellAtColumn:col row:row];
      
      if( [cell shouldBeSaved] ) {
        [cellsElement addChild:[cell xmlRepresentation]];
      }
    }
  }
  
  [layerElement addChild:cellsElement];
  
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  for( NSString *name in [[self scripts] allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
    
    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
    [cdataNode setStringValue:[[self scripts] objectForKey:name]];
    [scriptElement addChild:cdataNode];
    [scriptsElement addChild:scriptElement];
  }
  [layerElement addChild:scriptsElement];
  
  return layerElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self initWithPlayer:parent] ) ) {
    NSArray *nodes;
    
    NSString *idAttribute = [representation attributeAsString:@"id"];
    if( idAttribute == nil ) {
      *error = [[NSError alloc] initWithDomain:ELErrorDomain
                                             code:EL_ERR_LAYER_MISSING_ID
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Layer found without an ID attribute", NSLocalizedDescriptionKey, nil]];
      return nil;
    } else {
      [self setLayerId:idAttribute];
    }
    
    NSString *keyAttribute = [representation attributeAsString:@"key"];
    if( keyAttribute ) {
      [self setKey:[ELKey keyNamed:keyAttribute]];
    }
    
    [self setEnabledDial:[representation loadDial:@"enabled" parent:nil player:player error:error]];
    [self setChannelDial:[representation loadDial:@"channel" parent:nil player:player error:error]];
    [self setTempoDial:[representation loadDial:@"tempo" parent:[player tempoDial] player:player error:error]];
    [self setBarLengthDial:[representation loadDial:@"barLength" parent:[player barLengthDial] player:player error:error]];
    [self setTimeToLiveDial:[representation loadDial:@"timeToLive" parent:[player timeToLiveDial] player:player error:error]];
    [self setPulseEveryDial:[representation loadDial:@"pulseEvery" parent:[player pulseEveryDial] player:player error:error]];
    [self setVelocityDial:[representation loadDial:@"velocity" parent:[player velocityDial] player:player error:error]];
    [self setEmphasisDial:[representation loadDial:@"emphasis" parent:[player emphasisDial] player:player error:error]];
    [self setTempoSyncDial:[representation loadDial:@"tempoSync" parent:[player tempoSyncDial] player:player error:error]];
    [self setNoteLengthDial:[representation loadDial:@"noteLength" parent:[player noteLengthDial] player:player error:error]];
    [self setTransposeDial:[representation loadDial:@"transpose" parent:[player transposeDial] player:player error:error]];
    
    nodes = [representation nodesForXPath:@"cells/cell" error:error];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        NSXMLElement *element = (NSXMLElement *)node;
        NSXMLNode *attributeNode;
        
        attributeNode = [element attributeForName:@"col"];
        if( attributeNode == nil ) {
          *error = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_LAYER_CELL_REF_INVALID userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cell has no or invalid column reference",NSLocalizedDescriptionKey,nil]];
          return nil;
        }
        int col = [[attributeNode stringValue] intValue];
        
        attributeNode = [element attributeForName:@"row"];
        if( attributeNode == nil ) {
          *error = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_LAYER_CELL_REF_INVALID userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Cell has no or invalid row reference",NSLocalizedDescriptionKey,nil]];
          return nil;
        }
        int row = [[attributeNode stringValue] intValue];
        
        ELCell *cell = [[self cellAtColumn:col row:row] initWithXmlRepresentation:element parent:self player:player error:error];
        if( cell == nil ) {
          return nil;
        }
      }
    }
    
    // Scripts
    nodes = [representation nodesForXPath:@"scripts/script" error:error];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        NSXMLElement *element = (NSXMLElement *)node;
        [[self scripts] setObject:[[element stringValue] asJavascriptFunction]
                           forKey:[[element attributeForName:@"name"] stringValue]];
      }
    }
  }
  
  return self;
}


#pragma mark Cell drawing notifications

- (void)needsDisplay {
  if( [[self delegate] respondsToSelector:@selector(setNeedsDisplay:)] ) {
    [[self delegate] setNeedsDisplay:YES];
  }
}

@end
