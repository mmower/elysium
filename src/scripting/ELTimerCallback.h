//
//  ELTimerCallback.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import <Cocoa/Cocoa.h>

@class ELPlayer;

@interface ELTimerCallback : NSObject <ELXmlData> {
  BOOL            _active;
  NSTimeInterval  _interval;
  NSTimer         *_timer;
  ELScript        *_callback;
  ELPlayer        *_player;
}

- (id)initWithPlayer:(ELPlayer *)player;

@property  (nonatomic) BOOL active;
@property NSTimeInterval interval;
@property (nonatomic,readonly) ELScript *callback;
@property  (nonatomic,assign)  ELPlayer *player;

@end
