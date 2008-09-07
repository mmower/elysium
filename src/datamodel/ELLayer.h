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
@class ELStartTool;

@interface ELLayer : NSObject <LMHoneycombMatrix,ELData> {
  ELPlayer            *player;
  NSMutableArray      *hexes;
  ELConfig            *config;
  NSMutableArray      *playheads;
  NSMutableArray      *generators;
  int                 beatCount;
  id                  delegate;
  BOOL                visible;
}

- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel;

@property ELPlayer *player;
@property (readonly) ELConfig *config;
@property id delegate;
@property BOOL visible;

- (ELPlayer *)player;
- (ELHex *)hexAtColumn:(int)col row:(int)row;

// Dynamic Configuration

- (NSString *)layerId;
- (void)setLayerId:(NSString *)layerId;

- (BOOL)enabled;
- (void)setEnabled:(BOOL)enabled;

- (int)channel;
- (void)setChannel:(int)channel;

- (int)pulseCount;

- (void)addGenerator:(ELStartTool *)generator;
- (void)removeGenerator:(ELStartTool *)generator;

- (void)run;
- (void)stop;
- (void)reset;

- (void)clear;

- (void)playNote:(ELNote *)note velocity:(int)velocity duration:(float)duration;

- (void)removeAllPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

- (void)needsDisplay;

@end
