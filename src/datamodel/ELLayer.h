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
  id                  delegate;     // This will be the view representing us in the UI
  ELPlayer            *player;      // The player we belong to
  NSMutableArray      *hexes;       // The hexes representing the playing surface
  ELConfig            *config;      // Our configuration, linked to our player config
  NSMutableArray      *playheads;   // Array of playheads active on our surface
  NSMutableArray      *generators;  // Array of playhead generators (start tools)
  int                 beatCount;    // Current beat number
  BOOL                visible;      // Whether or not we are visible (not config, so not persistent)
  
  UInt64              timeBase;     // Our MIDI timebase, time of next beat can be calculated
                                    // from this, the tempo, and the beatcount. This should be
                                    // reset if the tempo is ever reset.
                                    
  NSThread            *runner;      // The thread that runs this layer
  BOOL                isRunning;    // Whether or not this layer is running
}

+ (NSPredicate *)deadPlayheadFilter;

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

- (int)velocity;
- (void)setVelocity:(int)velocity;

- (int)pulseCount;
- (int)timerResolution;

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
