//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELConfig;
@class ELPlayer;
@class ELPlayhead;

@interface ELLayer : NSObject {
  ELPlayer            *player;
  NSMutableArray      *hexes;
  ELConfig            *config;
  NSMutableArray      *playheads;
  int                 beatCount;
}

- (id)initWithPlayer:(ELPlayer *)player config:(ELConfig *)config;

- (ELHex *)hexAtCol:(int)col row:(int)row;

// Dynamic Configuration
- (int)instrument;
- (int)pulseCount;

- (void)run;
- (void)stop;

- (void)removeAllPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

@end
