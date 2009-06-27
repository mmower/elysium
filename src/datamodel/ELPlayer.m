//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

//#import <CoreAudio/HostTime.h>

#import "Elysium.h"

#define USE_TRIGGER_THREAD NO

#import "ELPlayer.h"

#import "ELCell.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"
#import "ELScriptPackage.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"
#import "ELMIDINoteMessage.h"

#import "ELToken.h"
#import "ELNoteToken.h"
#import "ELGenerateToken.h"

#import "ELOscillator.h"

static SEL updateSelector;

@implementation ELPlayer

#pragma mark Class methods

+ (void)initialize {
  if( !updateSelector ) {
    updateSelector = @selector(update);
  }
}


#pragma mark Initializers

- (id)init {
  if( ( self = [super init] ) ) {
    _harmonicTable   = [[ELHarmonicTable alloc] init];
    _layers          = [[NSMutableArray alloc] init];
    _selectedLayer   = nil;
    
    [self setTempoDial:[ELPlayer defaultTempoDial]];
    [self setBarLengthDial:[ELPlayer defaultBarLengthDial]];
    [self setTimeToLiveDial:[ELPlayer defaultTimeToLiveDial]];
    [self setPulseEveryDial:[ELPlayer defaultPulseEveryDial]];
    [self setVelocityDial:[ELPlayer defaultVelocityDial]];
    [self setEmphasisDial:[ELPlayer defaultEmphasisDial]];
    [self setTempoSyncDial:[ELPlayer defaultTempoSyncDial]];
    [self setNoteLengthDial:[ELPlayer defaultNoteLengthDial]];
    [self setTransposeDial:[ELPlayer defaultTransposeDial]];
    
    _activeOscillators = [[NSMutableArray alloc] init];
    
    _scriptingTag    = @"player";
    _scripts         = [NSMutableDictionary dictionary];
    _triggers        = [[NSMutableArray alloc] init];
    _pkg             = [[ELScriptPackage alloc] initWithPlayer:self];
    
    _nextLayerNumber = 1;
    _showNotes       = NO;
    _showOctaves     = NO;
    _showKey         = NO;
    _performanceMode = NO;
    
    // Note that we start this here, otherwise MIDI CC cannot be used to trigger the player itself
    if( USE_TRIGGER_THREAD ) {
      _triggerThread = [[NSThread alloc] initWithTarget:self selector:@selector(triggerMain) object:nil];
      [_triggerThread start];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:ELNotifyPlayerShouldStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:ELNotifyPlayerShouldStop object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMIDIControlMessage:) name:ELNotifyMIDIControl object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMIDINoteMessage:) name:ELNotifyMIDINote object:nil];
  }
  
  return self;
}


// There is an issue here!
- (id)initWithDocument:(ElysiumDocument *)document {
  if( ( self = [self init] ) ) {
    [self setDocument:document];
  }
  
  return self;
}


- (id)initWithDocument:(ElysiumDocument *)document createDefaultLayer:(BOOL)shouldCreateDefaultLayer {
  if( ( self = [self initWithDocument:document] ) ) {
    if( shouldCreateDefaultLayer ) {
      [self createLayer];
    }
  }
  
  return self;
}


#pragma mark Properties

// @synthesize startTime = _startTime;
@synthesize harmonicTable = _harmonicTable;
@synthesize layers = _layers;
@synthesize showNotes = _showNotes;
@synthesize showOctaves = _showOctaves;
@synthesize showKey = _showKey;
@synthesize performanceMode = _performanceMode;
@synthesize dirty = _dirty;


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

@synthesize document = _document;
@synthesize scripts = _scripts;
@synthesize scriptingTag = _scriptingTag;
@synthesize triggers = _triggers;
@synthesize pkg = _pkg;
@synthesize selectedLayer = _selectedLayer;
@synthesize activeOscillators = _activeOscillators;

+ (ELDial *)defaultTempoDial {
  return [[ELDial alloc] initWithName:@"tempo"
                              toolTip:@"Controls tempo in Beats Per Minute (BPM)"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTempoKey]
                                  min:15
                                  max:600
                                 step:1];
}

+ (ELDial *)defaultBarLengthDial {
  return [[ELDial alloc] initWithName:@"barLength"
                              toolTip:@"Controls how many beats there are to a bar."
                                  tag:0
                             assigned:4
                                  min:1
                                  max:24
                                 step:1];
}

+ (ELDial *)defaultTriggerModeDial {
  return [[ELDial alloc] initWithName:@"triggerMode"
                              toolTip:@"Controls the trigger for a generator to make new playheads."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:2
                                 step:1];
}

+ (ELDial *)defaultTimeToLiveDial {
  return [[ELDial alloc] initWithName:@"timeToLive"
                              toolTip:@"Controls how many beat a playhead lives for."
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTTLKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultPulseEveryDial {
  return [[ELDial alloc] initWithName:@"pulseEvery"
                              toolTip:@"Controls the beat on which generators create new playheads."
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultPulseCountKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultVelocityDial {
  return [[ELDial alloc] initWithName:@"velocity"
                              toolTip:@"Controls the MIDI velocity for notes except the first in each bar."
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultVelocityKey]
                                  min:1
                                  max:127
                                 step:1];
}

+ (ELDial *)defaultEmphasisDial {
  return [[ELDial alloc] initWithName:@"emphasis"
                              toolTip:@"Controls the MIDI velocity of the first note in each bar."
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultEmphasisKey]
                                  min:1
                                  max:127
                                 step:1];
}

+ (ELDial *)defaultTempoSyncDial {
  assert( YES == 1);
  assert( NO == 0 );
  return [[ELDial alloc] initWithName:@"tempoSync"
                              toolTip:@"Controls whether note length is sync'd to tempo or freely assigned."
                                  tag:0
                             assigned:NO
                                  min:NO
                                  max:YES
                                 step:1];
}

+ (ELDial *)defaultNoteLengthDial {
  return [[ELDial alloc] initWithName:@"noteLength"
                              toolTip:@"Controls the length of time over which a note is held."
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultDurationKey]
                                  min:100
                                  max:5000
                                 step:100];
}

+ (ELDial *)defaultTransposeDial {
  return [[ELDial alloc] initWithName:@"transpose"
                              toolTip:@"Controls note transposition from 2 octaves down to 2 octaves up."
                                  tag:0
                             assigned:0
                                  min:-24
                                  max:24
                                 step:1];
}

+ (ELDial *)defaultEnabledDial {
  return [[ELDial alloc] initWithName:@"enabled"
                              toolTip:@"Controls whether this object is enabled or not."
                                  tag:0
                            boolValue:YES];
}

+ (ELDial *)defaultPDial {
  return [[ELDial alloc] initWithName:@"p"
                              toolTip:@"Controls the probability that this object will be triggered."
                                  tag:0
                             assigned:100
                                  min:0
                                  max:100
                                 step:1];
}

+ (ELDial *)defaultGateDial {
  return [[ELDial alloc] initWithName:@"gate"
                              toolTip:@"Controls the number of playheads that must enter to trigger this object."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:32
                                 step:1];
}

+ (ELDial *)defaultDirectionDial {
  return [[ELDial alloc] initWithName:@"direction"
                              toolTip:@"Controls which direction playheads are generated in."
                                  tag:0
                             assigned:N
                                  min:0
                                  max:5
                                 step:1];
}

+ (ELDial *)defaultOffsetDial {
  return [[ELDial alloc] initWithName:@"offset"
                              toolTip:@"Controls how many beats playhead generation is offset by."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultTriadDial {
  return [[ELDial alloc] initWithName:@"triad"
                              toolTip:@"Controls whether (and which) triad will be played on this note."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:6
                                 step:1];
}

+ (ELDial *)defaultGhostsDial {
  return [[ELDial alloc] initWithName:@"ghosts"
                              toolTip:@"Controls the number of ghost notes that will play on subsequent beats."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:16
                                 step:1];
}

+ (ELDial *)defaultOverrideDial {
  return [[ELDial alloc] initWithName:@"override"
                              toolTip:@"Controls whether MIDI channel send overrides are in effect."
                                  tag:0
                            boolValue:NO];
}

+ (ELDial *)defaultBounceBackDial {
  return [[ELDial alloc] initWithName:@"bounceBack"
                              toolTip:@"Controls whether this split token will also send a playhead back along the original direction."
                                  tag:0
                            boolValue:NO];
}

+ (ELDial *)defaultClockWiseDial {
  return [[ELDial alloc] initWithName:@"clockwise"
                              toolTip:@"Controls whether this spinner rotates clockwise or anticlockwise."
                                  tag:0
                            boolValue:YES];
}

+ (ELDial *)defaultSteppingDial {
  return [[ELDial alloc] initWithName:@"stepping"
                              toolTip:@"Controls how many compass points this spinner rotates at a time."
                                  tag:0
                             assigned:1
                                  min:0
                                  max:5
                                 step:1];
}

+ (ELDial *)defaultSkipCountDial {
  return [[ELDial alloc] initWithName:@"skip"
                              toolTip:@"Controls how many extra cells a playhead skips over when it moves."
                                  tag:0
                             assigned:0
                                  min:0
                                  max:8
                                 step:1];
}

- (void)dialDidUnsetOscillator:(ELDial *)dial {
  [[self activeOscillators] removeObject:[dial oscillator]];
}

- (void)dialDidSetOscillator:(ELDial *)dial {
  [[self activeOscillators] addObject:[dial oscillator]];
}

// Player status & control

@synthesize running = _running;


- (void)start:(id)sender {
  [self performSelectorOnMainThread:@selector(runWillStartScript) withObject:nil waitUntilDone:YES];
  _oscillatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(runOscillators) object:nil];
  [_oscillatorThread start];
  [[self layers] makeObjectsPerformSelector:@selector(start)];
  [self setRunning:YES];
  [self performSelectorOnMainThread:@selector(runDidStartScript) withObject:nil waitUntilDone:YES];
}


- (void)stop:(id)sender {
  [self performSelectorOnMainThread:@selector(runWillStopScript) withObject:nil waitUntilDone:YES];
  [_oscillatorThread cancel];
  [[self layers] makeObjectsPerformSelector:@selector(stop)];
  [self setRunning:NO];
  [self performSelectorOnMainThread:@selector(runDidStopScript) withObject:nil waitUntilDone:YES];
}


- (void)reset {
  [[self layers] makeObjectsPerformSelector:@selector(reset)];
}


- (void)clearAll {
  [[self layers] makeObjectsPerformSelector:@selector(clear)];
}


- (void)runOscillators {
  UInt64 startNanos, elapsedNanos, delayMicros;
  
  while( ![_oscillatorThread isCancelled] ) {
    startNanos = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
    [[self activeOscillators] makeObjectsPerformSelector:updateSelector];
    elapsedNanos = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) - startNanos;
    delayMicros = 100000 - ( elapsedNanos / 1000 );
    if( delayMicros < 50000 ) {
      NSLog( @"Warning: oscillator thread interval below 50ms!" );
    }
    usleep( delayMicros );
  }
}


- (void)triggerMain {
  // Without any inputs attached a runloop will automatically exit
  // This would create a spin loop that will eat a lot of CPU
  [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
  
  do {
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    // [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
  } while( ![[NSThread currentThread] isCancelled] );
}


#pragma mark Scripting support

- (void)runWillStartScript {
  [[[self scripts] objectForKey:@"willStart"] evalWithArg:self];
}


- (void)runDidStartScript {
  [[[self scripts] objectForKey:@"didStart"] evalWithArg:self];
}


- (void)runWillStopScript {
  [[[self scripts] objectForKey:@"willStop"] evalWithArg:self];
}


- (void)runDidStopScript {
  [[[self scripts] objectForKey:@"didStop"] evalWithArg:self];
}


- (ELScript *)callbackTemplate {
  return [@"function(player) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
}


#pragma mark Drawing Support

- (void)toggleNoteDisplay {
  [self setShowNotes:![self showNotes]];
}


- (void)needsDisplay {
  [[self layers] makeObjectsPerformSelector:@selector(needsDisplay)];
}


#pragma mark Layer Management

- (ELLayer *)createLayer {
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:([self layerCount]+1)];
  
  [layer setLayerId:[NSString stringWithFormat:@"Layer-%d", _nextLayerNumber++]];
  
  [[layer tempoDial] setMode:dialInherited];
  [[layer barLengthDial] setMode:dialInherited];
  [[layer velocityDial] setMode:dialInherited];
  [[layer emphasisDial] setMode:dialInherited];
  [[layer tempoSyncDial] setMode:dialInherited];
  [[layer noteLengthDial] setMode:dialInherited];
  [[layer pulseEveryDial] setMode:dialInherited];
  [[layer timeToLiveDial] setMode:dialInherited];
  [[layer transposeDial] setMode:dialInherited];
  
  [self addLayer:layer];
  return layer;
}


- (void)addLayer:(ELLayer *)layer {
  [self willChangeValueForKey:@"layers"];
  [layer setPlayer:self];
  [[self layers] addObject:layer];
  [self didChangeValueForKey:@"layers"];
}


- (void)removeLayer:(ELLayer *)layer {
  [[self layers] removeObject:layer];
}


- (int)layerCount {
  return [[self layers] count];
}


- (ELLayer *)layer:(int)_index_ {
  return [[self layers] objectAtIndex:_index_];
}


// - (NSArray *)layers {
//   return [layers copy];
// }

- (void)removeLayers {
  for( ELLayer *layer in [[self layers] copy] ) {
    [self removeLayer:layer];
  }
}


#pragma mark Incoming MIDI message support

- (void)processMIDIControlMessage:(NSNotification *)notification {
  ELMIDIControlMessage *message = [notification object];
  
  if( USE_TRIGGER_THREAD ) {
    [self performSelector:@selector(handleMIDIControlMessage:) onThread:_triggerThread withObject:message waitUntilDone:NO];
  } else {
    [self performSelectorOnMainThread:@selector(handleMIDIControlMessage:) withObject:message waitUntilDone:NO];
  }
}


- (void)handleMIDIControlMessage:(ELMIDIControlMessage *)message {
  [[self triggers] makeObjectsPerformSelector:@selector(handleMIDIControlMessage:) withObject:message];
}


- (void)processMIDINoteMessage:(NSNotification *)notification {
  ELMIDIControlMessage *message = [notification object];
  
  if( USE_TRIGGER_THREAD ) {
    [self performSelector:@selector(handleMIDINoteMessage:) onThread:_triggerThread withObject:message waitUntilDone:NO];
  } else {
    [self performSelectorOnMainThread:@selector(handleMIDINoteMessage:) withObject:message waitUntilDone:NO];
  }
}


- (void)handleMIDINoteMessage:(ELMIDINoteMessage *)message {
  [[self layers] makeObjectsPerformSelector:@selector(handleMIDINoteMessage:) withObject:message];
}


#pragma mark Oscillator support

- (void)addOscillator:(ELOscillator *)oscillator {
  [self doesNotRecognizeSelector:_cmd];
}


#pragma mark Implements ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *surfaceElement = [NSXMLNode elementWithName:@"surface"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[[NSNumber numberWithInt:[[self harmonicTable] cols]] stringValue] forKey:@"columns"];
  [attributes setObject:[[NSNumber numberWithInt:[[self harmonicTable] rows]] stringValue] forKey:@"rows"];
  [surfaceElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[[self tempoDial] xmlRepresentation]];
  [controlsElement addChild:[[self barLengthDial] xmlRepresentation]];
  [controlsElement addChild:[[self timeToLiveDial] xmlRepresentation]];
  [controlsElement addChild:[[self pulseEveryDial] xmlRepresentation]];
  [controlsElement addChild:[[self velocityDial] xmlRepresentation]];
  [controlsElement addChild:[[self emphasisDial] xmlRepresentation]];
  [controlsElement addChild:[[self tempoSyncDial] xmlRepresentation]];
  [controlsElement addChild:[[self noteLengthDial] xmlRepresentation]];
  [controlsElement addChild:[[self transposeDial] xmlRepresentation]];
  
  [surfaceElement addChild:controlsElement];
  
  NSXMLElement *layersElement = [NSXMLNode elementWithName:@"layers"];
  for( ELLayer *layer in [self layers] ) {
    [layersElement addChild:[layer xmlRepresentation]];
  }
  [surfaceElement addChild:layersElement];
  
  NSXMLElement *triggersElement = [NSXMLNode elementWithName:@"triggers"];
  for( ELMIDITrigger *trigger in [self triggers] ) {
    [triggersElement addChild:[trigger xmlRepresentation]];
  }
  [surfaceElement addChild:triggersElement];
  
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
  [surfaceElement addChild:scriptsElement];
  
  [surfaceElement addChild:[[self pkg] xmlRepresentation]];
  
  return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self init] ) ) {
    NSArray *nodes;
    
    // Controls for the player
    *error = nil;
    
    [self setTempoDial:[representation loadDial:@"tempo" parent:nil player:player error:error]];
    [self setBarLengthDial:[representation loadDial:@"barLength" parent:nil player:player error:error]];
    [self setTimeToLiveDial:[representation loadDial:@"timeToLive" parent:nil player:player error:error]];
    [self setPulseEveryDial:[representation loadDial:@"pulseEvery" parent:nil player:player error:error]];
    [self setVelocityDial:[representation loadDial:@"velocity" parent:nil player:player error:error]];
    [self setEmphasisDial:[representation loadDial:@"emphasis" parent:nil player:player error:error]];
    [self setTempoSyncDial:[representation loadDial:@"tempoSync" parent:nil player:player error:error]];
    [self setNoteLengthDial:[representation loadDial:@"noteLength" parent:nil player:player error:error]];
    [self setTransposeDial:[representation loadDial:@"transpose" parent:nil player:player error:error]];
    
    // Layers
    nodes = [representation nodesForXPath:@"layers/layer" error:error];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        ELLayer *layer = [[ELLayer alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:self player:self error:error];
        if( layer == nil ) {
          return nil;
        } else {
          [self addLayer:layer];
          _nextLayerNumber++; // Ensure that future defined layers don't get a duplicate id.
        }
      }
    }
    
    // Triggers
    nodes = [representation nodesForXPath:@"triggers/trigger" error:error];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        ELMIDITrigger *trigger = [[ELMIDITrigger alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:self error:error];
        if( trigger == nil ) {
          return nil;
        } else {
          [[self triggers] addObject:trigger];
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
                           forKey:[element attributeAsString:@"name"]];
      }
    }
    
    // Convenient, even though there should only ever be one
    nodes = [representation nodesForXPath:@"package" error:error];
    if( nodes == nil ) {
      return nil;
    } else {
      NSXMLElement *element;;
      if( ( element = [nodes firstXMLElement] ) ) {
        _pkg = [[ELScriptPackage alloc] initWithXmlRepresentation:element parent:nil player:self error:error];
        if( _pkg == nil ) {
          return nil;
        }
      }
    }
  }
  
  return self;
}

@end
