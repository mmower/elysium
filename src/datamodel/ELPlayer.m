//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/HostTime.h>

#import "ELPlayer.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELOscillator.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELBeatTool.h"
#import "ELStartTool.h"

#define USE_CHANNELS 1

@implementation ELPlayer

- (id)init {
  if( ( self = [super init] ) ) {
    harmonicTable  = [[ELHarmonicTable alloc] init];
    layers         = [[NSMutableArray alloc] init];
    oscillators    = [[NSMutableDictionary alloc] init];
    
    tempoKnob       = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:600];
    timeToLiveKnob  = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16];
    pulseCountKnob  = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16];
    velocityKnob    = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:100];
    durationKnob    = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5];
    
    nextLayerNumber = 1;
    showNotes       = NO;
  }
  
  return self;
}


// There is an issue here!
- (id)initWithDocument:(ElysiumDocument *)_document_ midiController:(ELMIDIController *)_midiController_ {
  if( ( self = [self init] ) ) {
    [self setDocument:_document_];
    [self setMIDIController:_midiController_];
  }
  
  return self;
}

- (id)initWithDocument:(ElysiumDocument *)_document_ midiController:(ELMIDIController *)_midiController_ createDefaultLayer:(BOOL)_createDefaultLayer_ {
  if( ( self = [self initWithDocument:_document_ midiController:_midiController_] ) ) {
    if( _createDefaultLayer_ ) {
      [self createLayer];
    }
  }
  
  return self;
}

// Accessors

@synthesize startTime;
@synthesize harmonicTable;
@synthesize isRunning;
@synthesize showNotes;

@synthesize tempoKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize durationKnob;

// Associations

- (void)setMIDIController:(ELMIDIController *)_midiController {
  midiController = _midiController;
}

- (void)setDocument:(ElysiumDocument *)_document {
  document = _document;
}

- (void)toggleNoteDisplay {
  showNotes = !showNotes;
  [self needsDisplay];
}

// Player control

- (void)start {
  [layers makeObjectsPerformSelector:@selector(start)];
  isRunning = YES;
}

- (void)stop {
  [layers makeObjectsPerformSelector:@selector(stop)];
  isRunning = NO;
}

- (void)reset {
  [layers makeObjectsPerformSelector:@selector(reset)];
}

- (void)clearAll {
  [layers makeObjectsPerformSelector:@selector(clear)];
}

- (void)playNote:(ELNote *)_note_ channel:(int)_channel_ velocity:(int)_velocity_ duration:(float)_duration_ {
  UInt64 hostTime = AudioGetCurrentHostTime();
  // NSLog( @"hostTime = %llu", hostTime );
  UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000);
  // NSLog( @"onTime = %llu", onTime );
  UInt64 offTime = onTime + AudioConvertNanosToHostTime(_duration_ * 1000000000);
  // NSLog( @"offTime = %llu", offTime );
  [self scheduleNote:_note_ channel:_channel_ velocity:_velocity_ on:onTime off:offTime];
}

- (void)scheduleNote:(ELNote *)_note_ channel:(int)_channel_ velocity:(int)_velocity_ on:(UInt64)_on_ off:(UInt64)_off_ {
  NSLog( @"Play note %@ on channel:%d", _note_, _channel_ );
  ELMIDIMessage *message = [midiController createMessage];
  [message noteOn:[_note_ number] velocity:_velocity_ at:_on_ channel:_channel_];
  [message noteOff:[_note_ number] velocity:_velocity_ at:_off_ channel:_channel_];
  [message send];
  
}

// Drawing Support

- (void)needsDisplay {
  [layers makeObjectsPerformSelector:@selector(needsDisplay)];
}

// Layer Management

- (ELLayer *)createLayer {
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:([self layerCount]+1)];
  
  NSString *layerId = [NSString stringWithFormat:@"Layer-%d", nextLayerNumber++];
  [layer setLayerId:layerId];
  
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

// Oscillator support

- (void)addOscillator:(ELOscillator *)_oscillator_ {
  [oscillators setObject:_oscillator_ forKey:[_oscillator_ name]];
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
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  
  [surfaceElement addChild:controlsElement];
  
  NSXMLElement *layersElement = [NSXMLNode elementWithName:@"layers"];
  
  for( ELLayer *layer in layers ) {
    [layersElement addChild:[layer xmlRepresentation]];
  }
  
  [surfaceElement addChild:layersElement];
  
  return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ {
  if( ( self = [self init] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      tempoKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:self];
    } else {
      tempoKnob = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:600];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil];
    } else {
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil];
    } else {
      pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil];
    } else {
      velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:100];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:nil];
    } else {
      durationKnob = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5];
    }
    
    nodes = [_representation_ nodesForXPath:@"layers/layer" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      ELLayer *layer = [[ELLayer alloc] initWithXmlRepresentation:element parent:self];
      if( layer ) {
        [self addLayer:layer];
        nextLayerNumber++; // Ensure that future defined layers don't get a duplicate id.
      } else {
        NSLog( @"Player detected faulty layer, cannot load." );
        return nil;
      }
    }
  }
  
  return self;
}

@end
