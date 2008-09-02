//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELPlayer.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELTimer.h"
#import "ELLayer.h"
#import "ELConfig.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELBeatTool.h"
#import "ELStartTool.h"

#define USE_CHANNELS 1

@implementation ELPlayer

- (id)init {
  return [self initWithDefaultLayer:YES];
}

- (id)initWithDefaultLayer:(BOOL)_defaultLayer_ {
  if( self = [super init] ) {
    harmonicTable = [[ELHarmonicTable alloc] init];
    layers        = [[NSMutableArray alloc] init];
    config        = [[ELConfig alloc] init];
    timer         = [[ELTimer alloc] init];
    
    // Setup some default values
    [config setInteger:600 forKey:@"bpm"];
    [config setInteger:16 forKey:@"ttl"];
    [config setInteger:16 forKey:@"pulseCount"];
    [config setInteger:100 forKey:@"velocity"];
    [config setFloat:0.5 forKey:@"duration"];
    
    if( _defaultLayer_ ) {
      [layers addObject:[[ELLayer alloc] initWithPlayer:self channel:1]];
    }
  }
  
  return self;
}

// Accessors

@synthesize config;
@synthesize beatCount;
@synthesize startTime;
@synthesize harmonicTable;
@synthesize isRunning;

- (void)setMIDIController:(ELMIDIController *)_midiController {
  midiController = _midiController;
}

- (void)setDocument:(ElysiumDocument *)_document {
  document = _document;
}

// Player control

- (void)start {
  NSLog( @"Starting player thread." );
  
  [self reset];
  
  timerResolution = 60000000 / ( [config integerForKey:@"bpm"] );
  NSLog( @"Timer resolution = %u", timerResolution );
  
  isRunning = NO;
  thread    = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
  startTime = AudioGetCurrentHostTime();
  
  [thread start];
}

- (void)stop {
  [thread cancel];
}

- (void)reset {
  [layers makeObjectsPerformSelector:@selector(reset)];
}

- (void)run {
  NSLog( @"Player thread is running" );
  isRunning = YES;
  
  [config snapshot];
  
  while( ![thread isCancelled] ) {
    [self runOnce];
    usleep( timerResolution );
  }
  
  [config restore];
  [self reset];
  [document updateView:self];
  
  NSLog( @"Player has stopped." );
  isRunning = NO;
}

- (void)runOnce {
  [layers makeObjectsPerformSelector:@selector(run)];
  [document performSelectorOnMainThread:@selector(updateView:) withObject:self waitUntilDone:NO];
}

- (void)clearAll {
  [layers makeObjectsPerformSelector:@selector(clear)];
}

- (void)playNoteInBackground:(NSDictionary *)_noteInfo_ {
  int noteNumber = [[_noteInfo_ objectForKey:@"note"] integerValue];
  int velocity = [[_noteInfo_ objectForKey:@"velocity"] integerValue];
  int channel = [[_noteInfo_ objectForKey:@"channel"] integerValue];
  float duration = [[_noteInfo_ objectForKey:@"duration"] floatValue];
  
  NSLog( @"Play %d on channel %d with velocity %d, duration %0.1f", noteNumber, channel, velocity, duration );
  
  [midiController noteOn:noteNumber velocity:velocity channel:channel];
  usleep( duration * 1000000 );
  [midiController noteOff:noteNumber velocity:velocity channel:channel];
}

- (void)playNote:(ELNote *)_note_ channel:(int)_channel_ velocity:(int)_velocity_ duration:(float)_duration_ {
  NSLog( @"Play note %@ on channel %d with velocity %d for duration %0.02f", _note_, _channel_, _velocity_, _duration_ );
  
  NSMutableDictionary *noteInfo = [[NSMutableDictionary alloc] init];
  [noteInfo setObject:[NSNumber numberWithInt:_channel_] forKey:@"channel"];
  [noteInfo setObject:[NSNumber numberWithInt:[_note_ number]] forKey:@"note"];
  [noteInfo setObject:[NSNumber numberWithInt:_velocity_] forKey:@"velocity"];
  [noteInfo setObject:[NSNumber numberWithFloat:_duration_] forKey:@"duration"];
  [NSThread detachNewThreadSelector:@selector(playNoteInBackground:) toTarget:self withObject:noteInfo];
}

// Layer Management

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
  [layers removeAllObjects];
}

// Implementing the ELData protocol

- (NSXMLElement *)asXMLData {
  NSXMLElement *surfaceElement = [NSXMLNode elementWithName:@"surface"];
  
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  if( [config definesValueForKey:@"pulseCount"] ) {
    [attributes setObject:[config stringForKey:@"pulseCount"] forKey:@"pulseCount"];
  }
  if( [config definesValueForKey:@"velocity"] ) {
    [attributes setObject:[config stringForKey:@"velocity"] forKey:@"velocity"];
  }
  if( [config definesValueForKey:@"duration"] ) {
    [attributes setObject:[config stringForKey:@"duration"] forKey:@"duration"];
  }
  if( [config definesValueForKey:@"bpm"] ) {
    [attributes setObject:[config stringForKey:@"bpm"] forKey:@"bpm"];
  }
  if( [config definesValueForKey:@"ttl"] ) {
    [attributes setObject:[config stringForKey:@"ttl"] forKey:@"ttl"];
  }
  [surfaceElement setAttributesAsDictionary:attributes];
  
  for( ELLayer *layer in layers ) {
    [surfaceElement addChild:[layer asXMLData]];
  }
  
  return surfaceElement;
}

- (BOOL)fromXMLData:(NSXMLElement *)_xml_ {
  NSArray *nodes = [_xml_ nodesForXPath:@"surface" error:nil];
  if( [nodes count] != 1 ) {
    NSLog( @"Found %d surface elements, expected only 1" );
    return NO;
  }
  
  NSXMLElement *surfaceElement = [nodes objectAtIndex:0];
  
  NSXMLNode *node;
  if( node = [surfaceElement attributeForName:@"pulseCount"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"pulseCount"];
  }
  if( node = [surfaceElement attributeForName:@"velocity"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"velocity"];
  }
  if( node = [surfaceElement attributeForName:@"duration"] ) {
    [config setInteger:[[node stringValue] floatValue] forKey:@"duration"];
  }
  if( node = [surfaceElement attributeForName:@"bpm"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"bpm"];
  }
  if( node = [surfaceElement attributeForName:@"ttl"] ) {
    [config setInteger:[[node stringValue] intValue] forKey:@"ttl"];
  }
  
  nodes = [surfaceElement nodesForXPath:@"layer" error:nil];
  if( [nodes count] < 1 ) {
    NSLog( @"No layers defined!" );
    return NO;
  }
  
  for( NSXMLNode *node in nodes ) {
    NSXMLElement *layerElement = (NSXMLElement *)node;
    
    NSXMLNode *attribute = [layerElement attributeForName:@"channel"];
    if( !attribute ) {
      NSLog( @"Layer found with no channel number" );
      return NO;
    }
    
    int channel = [[attribute stringValue] intValue];
    if( channel < 1 || channel > USE_CHANNELS ) {
      NSLog( @"Channel defined outside range %d-%d", 1, USE_CHANNELS );
      return NO;
    }
    
    ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:channel];
    if( ![layer fromXMLData:layerElement] ) {
      NSLog( @"Problem loading layer data for layer:%d", channel );
      return NO;
    }
    
    [layers addObject:layer];
  }
  
  return YES;
}

@end