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
#import "ELHarmonicTable.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELBeatTool.h"
#import "ELStartTool.h"

@implementation ELPlayer

- (id)init {
  if( self = [super init] ) {
    harmonicTable = [[ELHarmonicTable alloc] init];
    layers        = [[NSMutableArray alloc] initWithCapacity:16];
    config        = [[ELConfig alloc] init];
    timer         = [[ELTimer alloc] init];
    
    // Setup some default values
    [config setInteger:300 forKey:@"bpm"];
    [config setInteger:16 forKey:@"ttl"];
    [config setInteger:16 forKey:@"pulseCount"];
    [config setInteger:100 forKey:@"velocity"];
    [config setFloat:1.0 forKey:@"duration"];
    
    for( int channel = 1; channel <= 16; channel++ ) {
      [layers addObject:[[ELLayer alloc] initWithPlayer:self channel:channel]];
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
  
  for( ELLayer *layer in layers ) {
    [layer reset];
  }
  
  timerResolution = 60000000 / ( [config integerForKey:@"bpm"] );
  NSLog( @"Timer resolution = %u", timerResolution );
  
  running   = NO;
  thread    = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
  startTime = AudioGetCurrentHostTime();
  
  [thread start];
}

- (void)stop {
  [thread cancel];
}

- (void)run {
  NSLog( @"Player thread is running" );
  running = YES;
  
  while( ![thread isCancelled] ) {
    
    for( ELLayer *layer in layers ) {
      [layer run];
    }
    
    // NSLog( @"Calling performSelectorOnMainThread:" );
    [document performSelectorOnMainThread:@selector(updateView:) withObject:self waitUntilDone:NO];
    
    usleep( timerResolution );
  }
  
  NSLog( @"Player has stopped." );
  running = NO;
}

- (void)playNote:(ELNote *)_note channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
  NSLog( @"Play note %@ on channel %d with velocity %d for duration %0.02f", _note, _channel, _velocity, _duration );
  // 
  // NSLog( @"Sending note ON" );
  // [midiController noteOn:[_note number] velocity:_velocity channel:_channel];
  // 
  // usleep( _duration * 1000000 );
  // 
  // NSLog( @"Sending note OFF" );
  // [midiController noteOff:[_note number] velocity:_velocity channel:_channel];
}

// Layer Management

- (ELLayer *)layerForChannel:(int)_channel {
  NSAssert1( _channel >= 1 && _channel <= 16, @"Requested invalid channel-%d", _channel );
  return [layers objectAtIndex:_channel-1];
}

@end
