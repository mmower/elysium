//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHoneycombMatrix.h>

#import "Elysium.h"

@class ELHex;
@class ELNote;
@class ELPlayer;
@class ELPlayhead;
@class ELGenerateTool;

@interface ELLayer : NSObject <LMHoneycombMatrix,ELXmlData> {
  id                  delegate;     // This will be the view representing us in the UI
  ELPlayer            *player;      // The player we belong to
  NSMutableArray      *hexes;       // The hexes representing the playing surface
  NSMutableArray      *playheads;   // Array of playheads active on our surface
  NSMutableArray      *generators;  // Array of playhead generators (start tools)
  int                 beatCount;    // Current beat number
  BOOL                visible;      // Whether or not we are visible (not config, so not persistent)
  
  UInt64              timeBase;     // Our MIDI timebase, time of next beat can be calculated
                                    // from this, the tempo, and the beatcount. This should be
                                    // reset if the tempo is ever reset.
                                    
  NSThread            *runner;      // The thread that runs this layer
  BOOL                isRunning;    // Whether or not this layer is running
  
  NSMutableDictionary *scripts;
  
  NSString            *layerId;
  
  ELHex               *selectedHex;
  
  ELBooleanKnob       *enabledKnob;
  ELIntegerKnob       *channelKnob;
  ELIntegerKnob       *tempoKnob;
  ELIntegerKnob       *timeToLiveKnob;
  ELIntegerKnob       *pulseCountKnob;
  ELIntegerKnob       *velocityKnob;
  ELFloatKnob         *durationKnob;
  ELIntegerKnob       *transposeKnob;
}

+ (NSPredicate *)deadPlayheadFilter;

- (id)initWithPlayer:(ELPlayer *)player;
- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel;

@property ELPlayer *player;
@property id delegate;
@property BOOL visible;
@property (assign) NSString *layerId;
@property ELHex *selectedHex;
@property int beatCount;

@property (readonly) ELBooleanKnob *enabledKnob;
@property (readonly) ELIntegerKnob *channelKnob;
@property (readonly) ELIntegerKnob *tempoKnob;
@property (readonly) ELIntegerKnob *timeToLiveKnob;
@property (readonly) ELIntegerKnob *pulseCountKnob;
@property (readonly) ELIntegerKnob *velocityKnob;
@property (readonly) ELFloatKnob *durationKnob;
@property (readonly) ELIntegerKnob *transposeKnob;

@property (readonly) NSMutableDictionary *scripts;

- (ELPlayer *)player;
- (ELHex *)hexAtColumn:(int)col row:(int)row;

// Dynamic Configuration

- (int)timerResolution;

- (void)addGenerator:(ELGenerateTool *)generator;
- (void)removeGenerator:(ELGenerateTool *)generator;

- (void)run;
- (void)stop;
- (void)reset;

- (void)clear;

- (void)playNote:(ELNote *)note velocity:(int)velocity duration:(float)duration;
- (void)playNotes:(NSArray *)notes velocity:(int)velocity duration:(float)duration;

- (void)removeAllPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

- (void)needsDisplay;

@end
