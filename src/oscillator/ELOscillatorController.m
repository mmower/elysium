//
//  ELOscillatorController.m
//  Elysium
//
//  Created by Matt Mower on 07/07/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELOscillatorController.h"

#import "ELDial.h"
#import "ELOscillator.h"

@interface ELOscillatorController (PrivateMethods)

- (void)run;

@end


@implementation ELOscillatorController

#pragma mark Object initialization

- (id)init {
  if( ( self = [super init] ) ) {
    _activeOscillators = [[NSMutableArray alloc] init];
  }
  
  return self;
}


#pragma mark Object behaviours


- (void)addOscillator:(ELOscillator *)oscillator {
  if( oscillator != nil ) {
    [_activeOscillators addObject:oscillator];
  }
}


- (void)removeOscillator:(ELOscillator *)oscillator {
  if( oscillator != nil ) {
    [_activeOscillators removeObject:oscillator];
  }
}


- (void)startOscillators {
  _oscillatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
  [_oscillatorThread start];
}


- (void)stopOscillators {
  [_oscillatorThread cancel];
}


- (void)run {
  UInt64 startNanos, elapsedNanos, delayMicros;
  SEL updateSelector = @selector(update);
  
  while( ![_oscillatorThread isCancelled] ) {
    startNanos = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() );
    // NSLog( @"activeOscillators: %d", [_activeOscillators count] );
    [_activeOscillators makeObjectsPerformSelector:updateSelector];
    elapsedNanos = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) - startNanos;
    delayMicros = 250000 - ( elapsedNanos / 1000 );
    if( delayMicros < 50000 ) {
      NSLog( @"Warning: oscillator thread interval below 50ms!" );
    }
    usleep( delayMicros );
  }
}


@end
