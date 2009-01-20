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
    
    tempoKnob       = [self defaultTempoKnob];
    barLengthKnob   = [self defaultBarLengthKnob];
    timeToLiveKnob  = [self defaultTimeToLiveKnob];
    pulseCountKnob  = [self defaultPulseCountKnob];
    velocityKnob    = [self defaultVelocityKnob];
    emphasisKnob    = [self defaultEmphasisKnob];
    durationKnob    = [self defaultDurationKnob];
    transposeKnob   = [self defaultTransposeKnob];
    
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

@synthesize tempoKnob;
@synthesize barLengthKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize emphasisKnob;
@synthesize durationKnob;
@synthesize transposeKnob;

@synthesize document;
@synthesize scripts;
@synthesize scriptingTag;
@synthesize triggers;
@synthesize pkg;
@synthesize selectedLayer;

- (ELIntegerKnob *)defaultTempoKnob {
  return [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:120 minimum:15 maximum:600 stepping:1];
}

- (ELIntegerKnob *)defaultBarLengthKnob {
  return [[ELIntegerKnob alloc] initWithName:@"barLength" integerValue:4 minimum:1 maximum:100 stepping:1];
}

- (ELIntegerKnob *)defaultTimeToLiveKnob {
  return [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16 minimum:1 maximum:64 stepping:1];
}

- (ELIntegerKnob *)defaultPulseCountKnob {
  return [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16 minimum:1 maximum:64 stepping:1];
}

- (ELIntegerKnob *)defaultVelocityKnob {
  return [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:90 minimum:1 maximum:127 stepping:1];
}

- (ELIntegerKnob *)defaultEmphasisKnob {
  return [[ELIntegerKnob alloc] initWithName:@"emphasis" integerValue:120 minimum:1 maximum:127 stepping:1];
}

- (ELIntegerKnob *)defaultDurationKnob {
  return [[ELIntegerKnob alloc] initWithName:@"duration" integerValue:500 minimum:100 maximum:5000 stepping:100];
}

- (ELIntegerKnob *)defaultTransposeKnob {
  return [[ELIntegerKnob alloc] initWithName:@"transpose" integerValue:0 minimum:-24 maximum:24 stepping:1];
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
  
  [[layer tempoKnob] setValue:[tempoKnob value]];
  [[layer barLengthKnob] setValue:[barLengthKnob value]];
  [[layer velocityKnob] setValue:[velocityKnob value]];
  [[layer emphasisKnob] setValue:[emphasisKnob value]];
  [[layer durationKnob] setValue:[durationKnob value]];
  [[layer pulseCountKnob] setValue:[pulseCountKnob value]];
  [[layer timeToLiveKnob] setValue:[timeToLiveKnob value]];
  [[layer transposeKnob] setValue:[transposeKnob value]];
  
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
  [controlsElement addChild:[tempoKnob xmlRepresentation]];
  [controlsElement addChild:[barLengthKnob xmlRepresentation]];
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[emphasisKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[transposeKnob xmlRepresentation]];
  
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

- (ELIntegerKnob *)loadIntegerKnobFrom:(NSXMLElement *)_element_ withError:(NSError **)_error_ andMessage:(NSString *)_message_ orCreateVia:(SEL)_default_ {
  ELIntegerKnob *knob;
  
  if( _element_ ) {
    knob = [[ELIntegerKnob alloc] initWithXmlRepresentation:_element_ parent:self player:self error:_error_];
  } else {
    knob = [self performSelector:_default_];
  }
  
  if( knob == nil ) {
    *_error_ = [NSError errorForLoadFailure:_message_ code:EL_ERR_PLAYER_LOAD_FAILURE withError:_error_];
  }
  
  return knob;
}

- (ELFloatKnob *)loadFloatKnobFrom:(NSXMLElement *)_element_ withError:(NSError **)_error_ andMessage:(NSString *)_message_ orCreateVia:(SEL)_default_ {
  ELFloatKnob *knob;
  
  if( _element_ ) {
    knob = [[ELFloatKnob alloc] initWithXmlRepresentation:_element_ parent:self player:self error:_error_];
  } else {
    knob = [self performSelector:_default_];
  }
  
  if( knob == nil ) {
    *_error_ = [NSError errorForLoadFailure:_message_ code:EL_ERR_PLAYER_LOAD_FAILURE withError:_error_];
  }
  
  return knob;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self init] ) ) {
    NSArray *nodes;
    
    // Controls for the player
    *_error_ = nil;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      tempoKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player tempoKnob" orCreateVia:@selector(defaultTempoKnob)];
      if( tempoKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='barLength']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      barLengthKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player barLengthKnob" orCreateVia:@selector(defaultBarLengthKnob)];
      if( barLengthKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      timeToLiveKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player timeToLiveKnob" orCreateVia:@selector(defaultTimeToLiveKnob)];
      if( timeToLiveKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      pulseCountKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player pulseCountKnob" orCreateVia:@selector(defaultPulseCountKnob)];
      if( pulseCountKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      velocityKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player velocityKnob" orCreateVia:@selector(defaultVelocityKnob)];
      if( velocityKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='emphasis']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      emphasisKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player emphasisKnob" orCreateVia:@selector(defaultEmphasisKnob)];
      if( emphasisKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      durationKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player durationKnob" orCreateVia:@selector(defaultDurationKnob)];
      if( durationKnob == nil ) {
        return nil;
      }
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='transpose']" error:_error_];
    if( nodes == nil ) {
      return nil;
    } else {
      transposeKnob = [self loadIntegerKnobFrom:[nodes firstXMLElement] withError:_error_ andMessage:@"Cannot load player tranposeKnob" orCreateVia:@selector(defaultTransposeKnob)];
      if( transposeKnob == nil ) {
        return nil;
      }
    }
    
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
