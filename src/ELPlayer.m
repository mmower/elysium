//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELPlayer.h"

#import "ELNote.h"
#import "ELLayer.h"
#import "ELConfig.h"
#import "ELHarmonicTable.h"

@implementation ELPlayer

- (id)init {
  if( self = [super init] ) {
    harmonicTable = [[ELHarmonicTable alloc] init];
    layers        = [[NSMutableArray alloc] init];
    config        = [[ELConfig alloc] init];
    thread        = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    // Setup some default values
    [config setInteger:300 forKey:@"bpm"];
    [config setInteger:16 forKey:@"ttl"];
    [config setInteger:16 forKey:@"pulseCount"];
    [config setInteger:100 forKey:@"velocity"];
    [config setFloat:1.0 forKey:@"duration"];
    NSLog( @"Dump config %@", config );
    [config dump];
    NSLog( @"-++-" );
  }
  
  return self;
}

- (void)start {
  NSLog( @"Starting player thread." );
  [thread start];
}

- (void)stop {
  [thread cancel];
}

- (void)run {
  while( ![thread isCancelled] ) {
    NSLog( @"Player thread is running" );
    
    for( ELLayer *layer in layers ) {
      [layer run];
    }
    
    sleep( 1.0 );
  }
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
  
  return [[ELLayer alloc] initWithPlayer:self config:layerConfig];
}

- (void)playNote:(ELNote *)_note channel:(int)_channel velocity:(int)_velocity duration:(float)_duration {
  NSLog( @"Play note %@ on channel %d with velocity %d for duration %0.02f", _note, _channel, _velocity, _duration );
}

@end
