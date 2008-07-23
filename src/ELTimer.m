//
//  ELTimer.m
//  Elysium
//
//  Created by Matt Mower on 21/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELTimer.h"

@implementation ELTimedEvent

- (id)initProgramChange:(int)_preset channel:(int)_channel at:(UInt64)_time {
  return [self initMessage:MIDI_PC channel:_channel arg0:_preset arg1:0 at:_time];
}

- (id)initNoteOn:(int)_note channel:(int)_channel velocity:(int)_velocity at:(UInt64)_time {
  return [self initMessage:MIDI_ON channel:_channel arg0:_note arg1:_velocity at:_time];
}

- (id)initNoteOff:(int)_note channel:(int)_channel velocity:(int)_velocity at:(UInt64)_time {
  return [self initMessage:MIDI_OFF channel:_channel arg0:_note arg1:_velocity at:_time];
}

- (id)initMessage:(int)_message channel:(int)_channel arg0:(int)_arg0 arg1:(int)_arg1 at:(UInt64)_time {
  if( self = [super init] ) {
    message = _message;
    channel = _channel;
    arg0    = _arg0;
    arg1    = _arg1;
    time    = _time;
  }
  
  return self;
}

- (id)delegate {
  return delegate;
}
- (void)setDelegate:(id)_delegate {
  delegate = _delegate;
}

- (void)run {
  switch( message ) {
    case MIDI_PC:
      if( [delegate respondsToSelector:@selector(programChange:channel:)] ) {
        [delegate programChange:arg0 channel:channel];
      }
      break;
      
    case MIDI_ON:
      if( [delegate respondsToSelector:@selector(noteOn:channel:velocity:)] ) {
        [delegate noteOn:arg0 channel:channel velocity:arg1];
      }
      break;
      
    case MIDI_OFF:
      if( [delegate respondsToSelector:@selector(noteOff:channel:velocity:)] ) {
        [delegate noteOff:arg0 channel:channel velocity:arg1];
      }
      break;
  }
}

@end

@implementation ELTimer

- (id)init {
  return [self initWithResolution:25000]; // Default resolution is 25ms
}

- (id)initWithResolution:(int)_resolution {
  if( self = [super init] ) {
    resolution = _resolution;
    queue      = [[NSMutableArray alloc] init];
    thread     = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    
    [thread start];
  }
  
  return self;
}

- (id)delegate {
  return delegate;
}

- (void)setDelegate:(id)_delegate {
  delegate = _delegate;
}

- (void)noteOn:(int)_note channel:(int)_channel velocity:(int)_velocity at:(UInt64)_time {
  [self enqueue:[[ELTimedEvent alloc] initNoteOn:_note channel:_channel velocity:_velocity at:_time]];
}

- (void)noteOff:(int)_note channel:(int)_channel velocity:(int)_velocity at:(UInt64)_time {
  [self enqueue:[[ELTimedEvent alloc] initNoteOff:_note channel:_channel velocity:_velocity at:_time]];
}

- (void)programChange:(int)_preset channel:(int)_channel at:(UInt64)_time {
  [self enqueue:[[ELTimedEvent alloc] initProgramChange:_preset channel:_channel at:_time]];
}

- (void)enqueue:(ELTimedEvent *)_event {
  if( ![thread isCancelled] ) {
    [_event setDelegate:[self delegate]];
    [queue addObject:_event];
  }
}

- (void)run {
  while( ![thread isCancelled] ) {
    [self dispatch];
    usleep( resolution );
  }
}

- (void)stop {
  [thread cancel];
}

- (void)dispatch {
  UInt64 now = AudioGetCurrentHostTime();
  
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"time < %@", now];
  
  NSArray *ready = [queue filteredArrayUsingPredicate:predicate];
  [queue filterUsingPredicate:predicate];
  
  for( ELTimedEvent *event in ready ) {
    [event run];
  }
}

@end
