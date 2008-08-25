//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELData.h"
#import <HoneycombView/LMHoneycombMatrix.h>

@class ELHex;
@class ELNote;
@class ELConfig;
@class ELPlayer;
@class ELPlayhead;

@interface ELLayer : NSObject <LMHoneycombMatrix,ELData> {
  ELPlayer            *player;
  NSMutableArray      *hexes;
  ELConfig            *config;
  NSMutableArray      *playheads;
  int                 beatCount;
}

- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel;

@property ELPlayer *player;
@property (readonly) ELConfig *config;

- (ELPlayer *)player;
- (ELHex *)hexAtColumn:(int)col row:(int)row;

// Dynamic Configuration
- (int)channel;
- (int)pulseCount;

- (void)run;
- (void)stop;
- (void)reset;

- (void)playNote:(ELNote *)note velocity:(int)velocity duration:(float)duration;

- (void)removeAllPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

@end
