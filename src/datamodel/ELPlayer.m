//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

//#import <CoreAudio/HostTime.h>

#import "ELPlayer.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELNoteTool.h"
#import "ELGenerateTool.h"

#import "ELOscillator.h"

#import "RubyBlock.h"

@implementation ELPlayer

- (id)init {
  if( ( self = [super init] ) ) {
    harmonicTable  = [[ELHarmonicTable alloc] init];
    layers         = [[NSMutableArray alloc] init];
    
    tempoKnob      = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:120 minimum:30 maximum:600 stepping:1];
    barLengthKnob  = [[ELIntegerKnob alloc] initWithName:@"barLength" integerValue:4 minimum:1 maximum:100 stepping:1];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16 minimum:1 maximum:999 stepping:1];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16 minimum:1 maximum:999 stepping:1];
    velocityKnob   = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:90 minimum:1 maximum:127 stepping:1];
    emphasisKnob   = [[ELIntegerKnob alloc] initWithName:@"emphasis" integerValue:120 minimum:1 maximum:127 stepping:1];
    durationKnob   = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5 minimum:0.1 maximum:5.0 stepping:0.1];
    transposeKnob  = [[ELIntegerKnob alloc] initWithName:@"transpose" integerValue:0 minimum:-36 maximum:36 stepping:1];
    
    scripts        = [NSMutableDictionary dictionary];
    triggers       = [[NSMutableArray alloc] init];
    
    nextLayerNumber = 1;
    showNotes       = NO;
    showOctaves     = NO;
    showKey         = NO;
    
    // Note that we start this here, otherwise MIDI CC cannot be used to trigger the player itself
    triggerThread = [[NSThread alloc] initWithTarget:self selector:@selector(triggerMain) object:nil];
    [triggerThread start];
    
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
@synthesize running;
@synthesize showNotes;
@synthesize showOctaves;
@synthesize showKey;

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
@synthesize triggers;

- (void)toggleNoteDisplay {
  showNotes = !showNotes;
}

// Player control

- (void)start:(id)_sender_ {
  if( ![self running] ) {
    NSLog( @"Player Start" );
    [self performSelectorOnMainThread:@selector(runWillStartScript) withObject:nil waitUntilDone:YES];
    [layers makeObjectsPerformSelector:@selector(start)];
    [self setRunning:YES];
    [self performSelectorOnMainThread:@selector(runDidStartScript) withObject:nil waitUntilDone:YES];
  }
}

- (void)stop:(id)_sender_ {
  if( [self running] ) {
    NSLog( @"Player Stop" );
    [self performSelectorOnMainThread:@selector(runWillStopScript) withObject:nil waitUntilDone:YES];
    // [triggerThread cancel];
    [layers makeObjectsPerformSelector:@selector(stop)];
    [self setRunning:NO];
    [self performSelectorOnMainThread:@selector(runDidStopScript) withObject:nil waitUntilDone:YES];
  }
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
  [self performSelector:@selector(handleMIDIControlMessage:) onThread:triggerThread withObject:_message_ waitUntilDone:NO];
}

- (void)handleMIDIControlMessage:(ELMIDIControlMessage *)_message_ {
  NSLog( @"handleMIDIControlMessage:%@", _message_ );
  [triggers makeObjectsPerformSelector:@selector(handleMIDIControlMessage:) withObject:_message_];
}

// Oscillator support

- (void)addOscillator:(ELOscillator *)_oscillator_ {
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
  
  return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_{
  if( ( self = [self init] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    // Controls for the player
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      tempoKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:self player:self];
    } else {
      tempoKnob = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:600 minimum:30 maximum:900 stepping:1];
    }

    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='barLength']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      barLengthKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:self player:self];
    } else {
      barLengthKnob = [[ELIntegerKnob alloc] initWithName:@"barLength" integerValue:4 minimum:1 maximum:100 stepping:1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16 minimum:1 maximum:999 stepping:1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16 minimum:1 maximum:999 stepping:1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:90 minimum:1 maximum:127 stepping:1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='emphasis']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      emphasisKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      emphasisKnob = [[ELIntegerKnob alloc] initWithName:@"emphasis" integerValue:120 minimum:1 maximum:127 stepping:1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      durationKnob = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5 minimum:0.1 maximum:5.0 stepping:0.1];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='transpose']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      transposeKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      transposeKnob = [[ELIntegerKnob alloc] initWithName:@"transpose" integerValue:0 minimum:-36 maximum:36 stepping:1];
    }
    
    // Layers
    
    nodes = [_representation_ nodesForXPath:@"layers/layer" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      ELLayer *layer = [[ELLayer alloc] initWithXmlRepresentation:element parent:self player:self];
      if( layer ) {
        [self addLayer:layer];
        nextLayerNumber++; // Ensure that future defined layers don't get a duplicate id.
      } else {
        NSLog( @"Player detected faulty layer, cannot load." );
        return nil;
      }
    }
    
    // Triggers
    nodes = [_representation_ nodesForXPath:@"triggers/trigger" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [triggers addObject:[[ELMIDITrigger alloc] initWithXmlRepresentation:element parent:nil player:self]];
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

@end
