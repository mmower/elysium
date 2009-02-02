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

#import "ELTool.h"
#import "ELNoteTool.h"
#import "ELGenerateTool.h"

#import "ELOscillator.h"

@implementation ELPlayer

- (id)init {
  if( ( self = [super init] ) ) {
    harmonicTable   = [[ELHarmonicTable alloc] init];
    layers          = [[NSMutableArray alloc] init];
    selectedLayer   = nil;
    
    tempoDial       = [ELPlayer defaultTempoDial];
    barLengthDial   = [ELPlayer defaultBarLengthDial];
    timeToLiveDial  = [ELPlayer defaultTimeToLiveDial];
    pulseEveryDial  = [ELPlayer defaultPulseEveryDial];
    velocityDial    = [ELPlayer defaultVelocityDial];
    emphasisDial    = [ELPlayer defaultEmphasisDial];
    tempoSyncDial   = [ELPlayer defaultTempoSyncDial];
    noteLengthDial  = [ELPlayer defaultNoteLengthDial];
    transposeDial   = [ELPlayer defaultTransposeDial];
    
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
- (id)initWithDocument:(ElysiumDocument *)_document_ {
  if( ( self = [self init] ) ) {
    [self setDocument:_document_];
  }
  
  return self;
}

- (id)initWithDocument:(ElysiumDocument *)_document_ createDefaultLayer:(BOOL)_createDefaultLayer_ {
  if( ( self = [self initWithDocument:_document_] ) ) {
    if( _createDefaultLayer_ ) {
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

@synthesize tempoDial;
@synthesize barLengthDial;
@synthesize timeToLiveDial;
@synthesize pulseEveryDial;
@synthesize velocityDial;
@synthesize emphasisDial;
@synthesize tempoSyncDial;
@synthesize noteLengthDial;
@synthesize transposeDial;

@synthesize document;
@synthesize scripts;
@synthesize scriptingTag;
@synthesize triggers;
@synthesize pkg;
@synthesize selectedLayer;

+ (ELDial *)defaultTempoDial {
  return [[ELDial alloc] initWithName:@"tempo"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTempoKey]
                                  min:15
                                  max:600
                                 step:1];
}

+ (ELDial *)defaultBarLengthDial {
  return [[ELDial alloc] initWithName:@"barLength"
                                  tag:0
                             assigned:4
                                  min:1
                                  max:24
                                 step:1];
}

+ (ELDial *)defaultTimeToLiveDial {
  return [[ELDial alloc] initWithName:@"timeToLive"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTTLKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultPulseEveryDial {
  return [[ELDial alloc] initWithName:@"pulseEvery"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultPulseCountKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultVelocityDial {
  return [[ELDial alloc] initWithName:@"velocity"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultVelocityKey]
                                  min:1
                                  max:127
                                 step:1];
}

+ (ELDial *)defaultEmphasisDial {
  return [[ELDial alloc] initWithName:@"emphasis"
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
                                  tag:0
                             assigned:NO
                                  min:NO
                                  max:YES
                                 step:1];
}

+ (ELDial *)defaultNoteLengthDial {
  return [[ELDial alloc] initWithName:@"noteLength"
                                  tag:0
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultDurationKey]
                                  min:100
                                  max:5000
                                 step:100];
}

+ (ELDial *)defaultTransposeDial {
  return [[ELDial alloc] initWithName:@"transpose"
                                  tag:0
                             assigned:0
                                  min:-24
                                  max:24
                                 step:1];
}

// Player status & control

@dynamic running;

- (BOOL)running {
  return running;
}

- (void)setRunning:(BOOL)_running_ {
  if( _running_ ) {
    if( ![self running] ) {
      [self start];
    }
  } else {
    if( [self running] ) {
      [self stop];
    }
  }
}

- (void)start:(id)_sender_ {
  [self setRunning:YES];
}

- (void)start {
  [self performSelectorOnMainThread:@selector(runWillStartScript) withObject:nil waitUntilDone:YES];
  [layers makeObjectsPerformSelector:@selector(start)];
  running = YES;
  [self performSelectorOnMainThread:@selector(runDidStartScript) withObject:nil waitUntilDone:YES];
}

- (void)stop:(id)_sender_ {
  [self setRunning:NO];
}

- (void)stop {
  [self performSelectorOnMainThread:@selector(runWillStopScript) withObject:nil waitUntilDone:YES];
  [layers makeObjectsPerformSelector:@selector(stop)];
  running = NO;
  [self performSelectorOnMainThread:@selector(runDidStopScript) withObject:nil waitUntilDone:YES];
}

- (void)reset {
  [layers makeObjectsPerformSelector:@selector(reset)];
}

- (void)clearAll {
  [layers makeObjectsPerformSelector:@selector(clear)];
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
