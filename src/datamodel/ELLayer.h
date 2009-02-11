//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHoneycombMatrix.h>

#import "Elysium.h"

@class ELHex;
@class ELKey;
@class ELNote;
@class ELPlayer;
@class ELPlayhead;
@class ELGenerateTool;

@interface ELLayer : NSObject <LMHoneycombMatrix,ELXmlData,ELTaggable> {
  id                  delegate;       // This will be the view representing us in the UI
  
  ELPlayer            *player;        // The player we belong to
  NSMutableArray      *hexes;         // The hexes representing the playing surface
  NSMutableArray      *playheads;     // Array of playheads active on our surface
  NSMutableArray      *playheadQueue; // Array of playheads to be queued onto the layer in the next beat
  NSMutableArray      *generators;    // Array of playhead generators (start tools)
  int                 beatCount;      // Current beat number
  BOOL                visible;        // Whether or not we are visible (not config, so not persistent)
                                    
  UInt64              timeBase;       // Our MIDI timebase, time of next beat can be calculated
                                      // from this, the tempo, and the beatcount. This should be
                                      // reset if the tempo is ever reset.
                                    
  NSThread            *runner;        // The thread that runs this layer
  BOOL                isRunning;      // Whether or not this layer is running
  
  NSMutableDictionary *scripts;
  NSString            *scriptingTag;
  
  NSString            *layerId;
  
  ELKey               *key;         // If this layer is in a musical key
  
  ELHex               *selectedHex;
  
  ELDial              *enabledDial;
  ELDial              *channelDial;
  ELDial              *tempoDial;
  ELDial              *barLengthDial;
  ELDial              *timeToLiveDial;
  ELDial              *pulseEveryDial;
  ELDial              *velocityDial;
  ELDial              *emphasisDial;
  ELDial              *tempoSyncDial;
  ELDial              *noteLengthDial;
  ELDial              *transposeDial;
}

+ (NSPredicate *)deadPlayheadFilter;

- (id)initWithPlayer:(ELPlayer *)player;
- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel;

@property           ELPlayer  *player;
@property           id        delegate;
@property           BOOL      visible;
@property (assign)  NSString  *layerId;
@property           ELHex     *selectedHex;
@property           int       beatCount;
@property           ELKey     *key;

@property (assign)  ELDial    *enabledDial;
@property (assign)  ELDial    *channelDial;
@property (assign)  ELDial    *tempoDial;
@property (assign)  ELDial    *barLengthDial;
@property (assign)  ELDial    *timeToLiveDial;
@property (assign)  ELDial    *pulseEveryDial;
@property (assign)  ELDial    *velocityDial;
@property (assign)  ELDial    *emphasisDial;
@property (assign)  ELDial    *tempoSyncDial;
@property (assign)  ELDial    *noteLengthDial;
@property (assign)  ELDial    *transposeDial;

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

- (BOOL)firstBeatInBar;

- (void)removeAllPlayheads;
- (void)queuePlayhead:(ELPlayhead *)playhead;
- (void)addQueuedPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

- (void)needsDisplay;

- (void)runWillRunScript;
- (void)runDidRunScript;
- (ELScript *)callbackTemplate;

@end
