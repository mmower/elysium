//
//  ELTimer.h
//  Elysium
//
//  Created by Matt Mower on 21/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSObject (ELTimedEventDelegate)
- (void)noteOn:(int)note channel:(int)channel velocity:(int)velocity;
- (void)noteOff:(int)note channel:(int)channel velocity:(int)velocity;
- (void)programChange:(int)preset channel:(int)channel;
@end

@interface ELTimedEvent : NSObject {
  UInt64  time;
  int     message;
  int     channel;
  int     arg0;
  int     arg1;
  
  id      delegate;
}

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (id)initProgramChange:(int)preset channel:(int)channel at:(UInt64)time;
- (id)initNoteOn:(int)note channel:(int)channel velocity:(int)velocity at:(UInt64)time;
- (id)initNoteOff:(int)note channel:(int)channel velocity:(int)velocity at:(UInt64)time;
- (id)initMessage:(int)message channel:(int)channel arg0:(int)arg0 arg1:(int)arg1 at:(UInt64)time;

@end

@interface NSObject (ELTimerDelegate)
@end

@interface ELTimer : NSObject {
  NSThread        *thread;
  int             resolution;
  NSMutableArray  *queue;
  id              delegate;
}

- (id)initWithResolution:(int)resolution;

- (id)delegate;
- (void)setDelegate:(id)delegate;

- (void)programChange:(int)present channel:(int)preset at:(UInt64)time;
- (void)noteOn:(int)note channel:(int)channel velocity:(int)velocity at:(UInt64)time;
- (void)noteOff:(int)note channel:(int)channel velocity:(int)velocity at:(UInt64)time;

- (void)enqueue:(ELTimedEvent *)event;

- (void)stop;
- (void)dispatch;

@end
