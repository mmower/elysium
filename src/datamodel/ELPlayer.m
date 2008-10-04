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
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELNoteTool.h"
#import "ELGenerateTool.h"

#import "ELFilter.h"

@implementation ELPlayer

- (id)init {
  if( ( self = [super init] ) ) {
    harmonicTable  = [[ELHarmonicTable alloc] init];
    layers         = [[NSMutableArray alloc] init];
    filters        = [[NSMutableArray alloc] init];
    
    tempoKnob      = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:600];
    timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16];
    pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16];
    velocityKnob   = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:100];
    durationKnob   = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5];
    transposeKnob  = [[ELIntegerKnob alloc] initWithName:@"transpose" integerValue:0];
    
    scripts        = [NSMutableDictionary dictionary];
    
    // Add a default filter, as much as a guide on creating new ones as anything else
    [filters addObject:[[ELFilter alloc] initWithName:@"Sine/1.0/60s" function:@"Sine" variance:1.0 period:60.0]];
    
    nextLayerNumber = 1;
    showNotes       = NO;
  }
  
  return self;
}


// There is an issue here!
- (id)initWithDocument:(ElysiumDocument *)_document_ midiController:(ELMIDIController *)_midiController_ {
  if( ( self = [self init] ) ) {
    [self setDocument:_document_];
    [self setMidiController:_midiController_];
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
@synthesize filters;

@synthesize tempoKnob;
@synthesize timeToLiveKnob;
@synthesize pulseCountKnob;
@synthesize velocityKnob;
@synthesize durationKnob;
@synthesize transposeKnob;

@synthesize document;
@synthesize midiController;
@synthesize scripts;

// Associations

- (void)setMIDIController:(ELMIDIController *)_midiController {
  midiController = _midiController;
}

- (void)toggleNoteDisplay {
  showNotes = !showNotes;
  [self needsDisplay];
}

// Player control

- (void)start {
  [[scripts objectForKey:@"willStart"] value:self];
  [layers makeObjectsPerformSelector:@selector(start)];
  isRunning = YES;
  [[scripts objectForKey:@"didStart"] value:self];
}

- (void)stop {
  [[scripts objectForKey:@"willStop"] value:self];
  [layers makeObjectsPerformSelector:@selector(stop)];
  isRunning = NO;
  [[scripts objectForKey:@"didStop"] value:self];
}

- (void)reset {
  [layers makeObjectsPerformSelector:@selector(reset)];
}

- (void)clearAll {
  [layers makeObjectsPerformSelector:@selector(clear)];
}

- (void)playNote:(int)_note_ channel:(int)_channel_ velocity:(int)_velocity_ duration:(float)_duration_ {
  UInt64 hostTime = AudioGetCurrentHostTime();
  UInt64 onTime = hostTime + AudioConvertNanosToHostTime(50000000);
  UInt64 offTime = onTime + AudioConvertNanosToHostTime(_duration_ * 1000000000);
  [self scheduleNote:_note_ channel:_channel_ velocity:_velocity_ on:onTime off:offTime];
}

- (void)scheduleNote:(int)_note_ channel:(int)_channel_ velocity:(int)_velocity_ on:(UInt64)_on_ off:(UInt64)_off_ {
  NSLog( @"Play note %d (velocity:%d channel:%d tempo:%d)", _note_, _velocity_, _channel_, [tempoKnob filteredValue] );
  ELMIDIMessage *message = [midiController createMessage];
  
  [message noteOn:_note_ velocity:_velocity_ at:_on_ channel:_channel_];
  [message noteOff:_note_ velocity:_velocity_ at:_off_ channel:_channel_];
  [message send];
}

// Drawing Support

- (void)needsDisplay {
  [layers makeObjectsPerformSelector:@selector(needsDisplay)];
}

- (NSArray *)filterFunctions {
  return (NSArray *)ELFilterFunctions;
}

// Layer Management

- (ELLayer *)createLayer {
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:([self layerCount]+1)];
  
  [layer setLayerId:[NSString stringWithFormat:@"Layer-%d", nextLayerNumber++]];
  
  [[layer tempoKnob] setValue:[tempoKnob value]];
  [[layer velocityKnob] setValue:[velocityKnob value]];
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

// Oscillator support

- (void)addFilter:(ELFilter *)_filter_ {
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
  [controlsElement addChild:[timeToLiveKnob xmlRepresentation]];
  [controlsElement addChild:[pulseCountKnob xmlRepresentation]];
  [controlsElement addChild:[velocityKnob xmlRepresentation]];
  [controlsElement addChild:[durationKnob xmlRepresentation]];
  [controlsElement addChild:[transposeKnob xmlRepresentation]];
  
  [surfaceElement addChild:controlsElement];
  
  NSXMLElement *filtersElement = [NSXMLNode elementWithName:@"filters"];
  for( ELFilter *filter in filters ) {
    [filtersElement addChild:[filter xmlRepresentation]];
  }
  [surfaceElement addChild:filtersElement];
  
  NSXMLElement *layersElement = [NSXMLNode elementWithName:@"layers"];
  for( ELLayer *layer in layers ) {
    [layersElement addChild:[layer xmlRepresentation]];
  }
  [surfaceElement addChild:layersElement];
  
  NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
  for( NSString *name in [scripts allKeys] ) {
    NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
    
    [attributes removeAllObjects];
    [attributes setObject:name forKey:@"name"];
    [scriptElement setAttributesAsDictionary:attributes];
    [scriptElement setStringValue:[scripts objectForKey:name]];
    
    [scriptsElement addChild:scriptElement];
  }
  [surfaceElement addChild:scriptsElement];
  
  return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_{
  if( ( self = [self init] ) ) {
    NSXMLElement *element;
    NSArray *nodes;
    
    // Restore the filters first, so that they can be referenced elsewhere
    
    nodes = [_representation_ nodesForXPath:@"filters/filter" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      ELFilter *filter = [[ELFilter alloc] initWithXmlRepresentation:element parent:nil player:self];
      NSLog( @"Adding filter: %@", filter );
      [filters addObject:filter];
    }
    
    // Controls for the player
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='tempo']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      tempoKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:self player:self];
    } else {
      tempoKnob = [[ELIntegerKnob alloc] initWithName:@"tempo" integerValue:600];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='timeToLive']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      timeToLiveKnob = [[ELIntegerKnob alloc] initWithName:@"timeToLive" integerValue:16];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='pulseCount']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      pulseCountKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      pulseCountKnob = [[ELIntegerKnob alloc] initWithName:@"pulseCount" integerValue:16];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='velocity']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      velocityKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      velocityKnob = [[ELIntegerKnob alloc] initWithName:@"velocity" integerValue:100];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='duration']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      durationKnob = [[ELFloatKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      durationKnob = [[ELFloatKnob alloc] initWithName:@"duration" floatValue:0.5];
    }
    
    nodes = [_representation_ nodesForXPath:@"controls/knob[@name='transpose']" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      transposeKnob = [[ELIntegerKnob alloc] initWithXmlRepresentation:element parent:nil player:self];
    } else {
      transposeKnob = [[ELIntegerKnob alloc] initWithName:@"transpose" integerValue:0];
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
    
    // Scripts
    nodes = [_representation_ nodesForXPath:@"scripts/script" error:nil];
    for( NSXMLNode *node in nodes ) {
      NSXMLElement *element = (NSXMLElement *)node;
      [scripts setObject:[[element stringValue] asBlock]
                  forKey:[[element attributeForName:@"name"] stringValue]];
    }
  }
  
  return self;
}

@end
