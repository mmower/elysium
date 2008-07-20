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
#import "ELLayer.h"
#import "ELConfig.h"
#import "ELHarmonicTable.h"
#import "ELMIDIController.h"

#import "ELTool.h"
#import "ELStartTool.h"

@implementation ELPlayer

- (id)init {
  if( self = [super init] ) {
    harmonicTable = [[ELHarmonicTable alloc] init];
    layers        = [[NSMutableArray alloc] init];
    config        = [[ELConfig alloc] init];
    thread        = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    running       = NO;
    
    // Setup some default values
    [config setInteger:300 forKey:@"bpm"];
    [config setInteger:16 forKey:@"ttl"];
    [config setInteger:16 forKey:@"pulseCount"];
    [config setInteger:100 forKey:@"velocity"];
    [config setFloat:1.0 forKey:@"duration"];
  }
  
  return self;
}

- (void)start:(ELMIDIController *)_midiController {
  NSLog( @"Starting player thread." );
  midiController = _midiController;
  [thread start];
}

- (void)stop {
  [thread cancel];
}

- (BOOL)isRunning {
  return running;
}

- (void)run {
  running = YES;
  while( ![thread isCancelled] ) {
    NSLog( @"Player thread is running" );
    
    for( ELLayer *layer in layers ) {
      [layer run];
    }
    
    sleep( 1.0 );
  }
  
  NSLog( @"Player has stopped." );
  running = NO;
}

- (ELHarmonicTable *)harmonicTable
{
  return harmonicTable;
}

- (void)addLayer {
  [layers addObject:[self createLayer:1]];
}

- (ELLayer *)createLayer:(int)_channel {
  NSLog( @"Creating layer for channel %d", _channel );
    
  ELConfig *layerConfig = [[ELConfig alloc] initWithParent:config];
  [layerConfig setInteger:_channel forKey:@"channel"];
  
  ELLayer *layer = [[ELLayer alloc] initWithPlayer:self config:layerConfig];
  
  ELConfig *toolConfig = [[ELConfig alloc] initWithParent:layerConfig];
  [toolConfig setInteger:N forKey:@"direction"];
  
  [[layer hexAtCol:6 row:5] addTool:[[ELStartTool alloc] initWithType:@"start" config:toolConfig]];
  
  return layer;
}

- (void)playNote:(ELNote *)_note channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
  NSLog( @"Play note %@ on channel %d with velocity %d for duration %0.02f", _note, _channel, _velocity, _duration );
}

@end
