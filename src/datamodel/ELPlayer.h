//
//  ELPlayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELData.h"

@class ELNote;
@class ELLayer;
@class ELTimer;
@class ELConfig;
@class ELHarmonicTable;
@class ELMIDIController;
@class ElysiumDocument;

@interface ELPlayer : NSObject <ELData> {
  ElysiumDocument   *document;
  ELHarmonicTable   *harmonicTable;
  NSMutableArray    *layers;
  ELConfig          *config;
  NSThread          *thread;
  BOOL              isRunning;
  ELTimer           *timer;
  ELMIDIController  *midiController;
  int               beatCount;
  int               timerResolution;
  UInt64            startTime;
}

@property (readonly) ELConfig *config;
@property (readonly) int beatCount;
@property (readonly) UInt64 startTime;
@property (readonly) ELHarmonicTable *harmonicTable;
@property (readonly) BOOL isRunning;

- (id)initWithDocument:(ElysiumDocument *)document midiController:(ELMIDIController *)_midiController_;
- (id)initWithDocument:(ElysiumDocument *)document midiController:(ELMIDIController *)_midiController_ createDefaultLayer:(BOOL)createDefaultLayer;

- (int)tempo;
- (void)setTempo:(int)tempo;
- (int)timeToLive;
- (void)setTimeToLive:(int)ttl;
- (int)pulseCount;
- (void)setPulseCount:(int)pulseCount;
- (int)velocity;
- (void)setVelocity:(int)velocity;
- (float)duration;
- (void)setDuration:(float)duration;
  
- (void)setMIDIController:(ELMIDIController *)midiController;
- (void)setDocument:(ElysiumDocument *)document;

- (void)run;
- (void)runOnce;
- (void)start;
- (void)stop;
- (void)reset;

- (void)clearAll;

- (void)playNote:(ELNote *)note channel:(int)channel velocity:(int)velocity duration:(float)duration;
- (void)scheduleNote:(ELNote *)note channel:(int)channel velocity:(int)velocity on:(UInt64)on off:(UInt64)off;

// Drawing support

- (void)needsDisplay;

// Layer management
- (ELLayer *)createLayer;
- (void)addLayer:(ELLayer *)layer;
- (int)layerCount;
- (void)removeLayers;
- (NSArray *)layers;
- (ELLayer *)layer:(int)index;

@end
