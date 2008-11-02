//
//  ELTimerCallback.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import <Cocoa/Cocoa.h>

@class ELPlayer;
@class RubyBlock;

@interface ELTimerCallback : NSObject <ELXmlData> {
  BOOL            active;
  NSTimeInterval  interval;
  NSTimer         *timer;
  RubyBlock       *callback;
  ELPlayer        *player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property BOOL active;
@property NSTimeInterval interval;
@property (readonly) RubyBlock *callback;
@property (assign) ELPlayer *player;

- (void)runCallback:(NSTimer *)_timer_;

@end
