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

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"
#import "ELScriptPackage.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

#import "ELToken.h"
#import "ELNoteToken.h"
#import "ELGenerateToken.h"

#import "ELOscillator.h"

static SEL updateSelector;

@implementation ELPlayer

+ (void)initialize {
  if( !updateSelector ) {
    updateSelector = @selector(update);
  }
}

- (id)init {
  if( ( self = [super init] ) ) {
    harmonicTable   = [[ELHarmonicTable alloc] init];
    layers          = [[NSMutableArray alloc] init];
    selectedLayer   = nil;
    
    [self setTempoDial:[ELPlayer defaultTempoDial]];
    [self setBarLengthDial:[ELPlayer defaultBarLengthDial]];
    [self setTimeToLiveDial:[ELPlayer defaultTimeToLiveDial]];
    [self setPulseEveryDial:[ELPlayer defaultPulseEveryDial]];
    [self setVelocityDial:[ELPlayer defaultVelocityDial]];
    [self setEmphasisDial:[ELPlayer defaultEmphasisDial]];
    [self setTempoSyncDial:[ELPlayer defaultTempoSyncDial]];
    [self setNoteLengthDial:[ELPlayer defaultNoteLengthDial]];
    [self setTransposeDial:[ELPlayer defaultTransposeDial]];
    
    activeOscillators = [[NSMutableArray alloc] init];
    
    scriptingTag    = @"player";
    scripts         = [NSMutableDictionary dictionary];
    triggers        = [[NSMutableArray alloc] init];
    pkg             = [[ELScriptPackage alloc] initWithPlayer:self];
    
    nextLayerNumber = 1;
    showNotes       = NO;
    showOctaves     = NO;
    showKey         = NO;
    performanceMode = NO;
    
    // Note that we start this here, otherwise MIDI CC cannot be used to trigger the player itself
    if( USE_TRIGGER_THREAD ) {
      triggerThread = [[NSThread alloc] initWithTarget:self selector:@selector(triggerMain) object:nil];
      [triggerThread start];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:ELNotifyPlayerShouldStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:ELNotifyPlayerShouldStop object:nil];
  }
  
  return self;
}


// There is an issue here!
- (id)initWithDocument:(ElysiumDocument *)theDocument {
  if( ( self = [self init] ) ) {
    [self setDocument:theDocument];
  }
  
  return self;
}

- (id)initWithDocument:(ElysiumDocument *)theDocument createDefaultLayer:(BOOL)shouldCreateDefaultLayer {
  if( ( self = [self initWithDocument:theDocument] ) ) {
    if( shouldCreateDefaultLayer ) {
      [self createLayer];
    }
  }
  
  return self;
}

// Accessors

@synthesize startTime;
@synthesize harmonicTable;
@synthesize showNotes;
@synthesize showOctaves;
@synthesize showKey;
@synthesize performanceMode;

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

@synthesize document;
@synthesize scripts;
@synthesize scriptingTag;
@synthesize triggers;
@synthesize pkg;
@synthesize selectedLayer;
@synthesize activeOscillators;

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
  [activeOscillators removeObject:[dial oscillator]];
}

- (void)dialDidSetOscillator:(ELDial *)dial {
  [activeOscillators addObject:[dial oscillator]];
}

// Player status & control

@synthesize running;

- (void)start:(id)sender {
  [self performSelectorOnMainThread:@selector(runWillStartScript) withObject:nil waitUntilDone:YES];
  oscillatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(runOscillators) object:nil];
  [oscillatorThread start];
  [layers makeObjectsPerformSelector:@selector(start)];
  [self setRunning:YES];
  [self performSelectorOnMainThread:@selector(runDidStartScript) withObject:nil waitUntilDone:YES];
}

- (void)stop:(id)sender {
  [self performSelectorOnMainThread:@selector(runWillStopScript) withObject:nil waitUntilDone:YES];
  [oscillatorThread cancel];
  [layers makeObjectsPerformSelector:@selector(stop)];
  [self setRunning:NO];
  [self performSelectorOnMainThread:@selector(runDidStopScript) withObject:nil waitUntilDone:YES];
}

- (void)reset {
  [layers makeObjectsPerformSelector:@selector(reset)];
}

- (void)clearAll {
  [layers makeObjectsPerformSelector:@selector(clear)];
}

- (void)runOscillators {
  UInt64 startNanos, elapsedNanos, delayMicros;
  
  while( ![oscillatorThread isCancelled] ) {
    startNanos = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
    [activeOscillators makeObjectsPerformSelector:updateSelector];
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

// Scripting

- (void)runWillStartScript {
  [[scripts objectForKey:@"willStart"] evalWithArg:self];
}

- (void)runDidStartScript {
  [[scripts objectForKey:@"didStart"] evalWithArg:self];
}

- (void)runWillStopScript {
  [[scripts objectForKey:@"willStop"] evalWithArg:self];
}

- (void)runDidStopScript {
  [[scripts objectForKey:@"didStop"] evalWithArg:self];
}

- (ELScript *)callbackTemplate {
  return [@"function(player) {\n\t// write your callback code here\n}\n" asJavascriptFunction];
}

// Drawing Support

- (void)toggleNoteDisplay {
  showNotes = !showNotes;
}

- (void)needsDisplay {
  [layers makeObjectsPerformSelector:@selector(needsDisplay)];
}

// Layer Management

- (ELLayer *)createLayer {
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:([self layerCount]+1)];
  
  [layer setLayerId:[NSString stringWithFormat:@"Layer-%d", nextLayerNumber++]];
  
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

- (void)addLayer:(ELLayer *)_layer_ {
  [self willChangeValueForKey:@"layers"];
  [_layer_ setPlayer:self];
  [layers addObject:_layer_];
  [self didChangeValueForKey:@"layers"];
}

- (void)removeLayer:(ELLayer *)_layer_ {
  [layers removeObject:_layer_];
}

- (int)layerCount {
  return [layers count];
}

- (ELLayer *)layer:(int)_index_ {
  return [layers objectAtIndex:_index_];
}

- (NSArray *)layers {
  return [layers copy];
}

- (void)removeLayers {
  for( ELLayer *layer in [layers copy] ) {
    [self removeLayer:layer];
  }
}

// MIDI Trigger support

- (void)processMIDIControlMessage:(ELMIDIControlMessage *)_message_ {
  NSLog( @"processMIDIControlMessage:%@", _message_ );
  
  if( USE_TRIGGER_THREAD ) {
    [self performSelector:@selector(handleMIDIControlMessage:) onThread:triggerThread withObject:_message_ waitUntilDone:NO];
  } else {
    [self performSelectorOnMainThread:@selector(handleMIDIControlMessage:) withObject:_message_ waitUntilDone:NO];
  }
  
}

- (void)handleMIDIControlMessage:(ELMIDIControlMessage *)_message_ {
  NSLog( @"handleMIDIControlMessage:%@", _message_ );
  [triggers makeObjectsPerformSelector:@selector(handleMIDIControlMessage:) withObject:_message_];
}

// Oscillator support

- (void)addOscillator:(ELOscillator *)_oscillator_ {
  [self doesNotRecognizeSelector:_cmd];
  // [oscillators setObject:_oscillator_ forKey:[_oscillator_ name]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *surfaceElement = [NSXMLNode elementWithName:@"surface"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[[NSNumber numberWithInt:[harmonicTable cols]] stringValue] forKey:@"columns"];
  [attributes setObject:[[NSNumber numberWithInt:[harmonicTable rows]] stringValue] forKey:@"rows"];
  [surfaceElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
  [controlsElement addChild:[tempoDial xmlRepresentation]];
  [controlsElement addChild:[barLengthDial xmlRepresentation]];
  [controlsElement addChild:[timeToLiveDial xmlRepresentation]];
  [controlsElement addChild:[pulseEveryDial xmlRepresentation]];
  [controlsElement addChild:[velocityDial xmlRepresentation]];
  [controlsElement addChild:[emphasisDial xmlRepresentation]];
  [controlsElement addChild:[tempoSyncDial xmlRepresentation]];
  [controlsElement addChild:[noteLengthDial xmlRepresentation]];
  [controlsElement addChild:[transposeDial xmlRepresentation]];
  
  [surfaceElement addChild:controlsElement];
  
  NSXMLElement *layersElement = [NSXMLNode elementWithName:@"layers"];
  for( ELLayer *layer in layers ) {
    [layersElement addChild:[layer xmlRepresentation]];
  }
  [surfaceElement addChild:layersElement];
  
  NSXMLElement *triggersElement = [NSXMLNode elementWithName:@"triggers"];
  for( ELMIDITrigger *trigger in [self triggers] ) {
    [triggersElement addChild:[trigger xmlRepresentation]];
  }
  [surfaceElement addChild:triggersElement];
  
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
  [surfaceElement addChild:scriptsElement];
  
  [surfaceElement addChild:[pkg xmlRepresentation]];
  
  return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self init] ) ) {
    NSArray *nodes;
    
    // Controls for the player
    *_error_ = nil;
    
    [self setTempoDial:[_representation_ loadDial:@"tempo" parent:nil player:_player_ error:_error_]];
    [self setBarLengthDial:[_representation_ loadDial:@"barLength" parent:nil player:_player_ error:_error_]];
    [self setTimeToLiveDial:[_representation_ loadDial:@"timeToLive" parent:nil player:_player_ error:_error_]];
    [self setPulseEveryDial:[_representation_ loadDial:@"pulseEvery" parent:nil player:_player_ error:_error_]];
    [self setVelocityDial:[_representation_ loadDial:@"velocity" parent:nil player:_player_ error:_error_]];
    [self setEmphasisDial:[_representation_ loadDial:@"emphasis" parent:nil player:_player_ error:_error_]];
    [self setTempoSyncDial:[_representation_ loadDial:@"tempoSync" parent:nil player:_player_ error:_error_]];
    [self setNoteLengthDial:[_representation_ loadDial:@"noteLength" parent:nil player:_player_ error:_error_]];
    [self setTransposeDial:[_representation_ loadDial:@"transpose" parent:nil player:_player_ error:_error_]];
    
    // Layers
    nodes = [_representation_ nodesForXPath:@"layers/layer" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        ELLayer *layer = [[ELLayer alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:self player:self error:_error_];
        if( layer == nil ) {
          return nil;
        } else {
          [self addLayer:layer];
          nextLayerNumber++; // Ensure that future defined layers don't get a duplicate id.
        }
      }
    }
    
    // Triggers
    nodes = [_representation_ nodesForXPath:@"triggers/trigger" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      for( NSXMLNode *node in nodes ) {
        ELMIDITrigger *trigger = [[ELMIDITrigger alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:self error:_error_];
        if( trigger == nil ) {
          return nil;
        } else {
          [triggers addObject:trigger];
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
                    forKey:[element attributeAsString:@"name"]];
      }
    }
    
    // Convenient, even though there should only ever be one
    nodes = [_representation_ nodesForXPath:@"package" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      NSXMLElement *element;;
      if( ( element = [nodes firstXMLElement] ) ) {
        pkg = [[ELScriptPackage alloc] initWithXmlRepresentation:element parent:nil player:self error:_error_];
        if( pkg == nil ) {
          return nil;
        }
      }
    }
  }
  
  return self;
}

@end
