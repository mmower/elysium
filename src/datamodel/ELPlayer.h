//
//  ELPlayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"



@class ELNote;
@class ELLayer;
@class ELTimer;
@class ELConfig;
@class ELHarmonicTable;
@class ELMIDIController;
@class ElysiumDocument;
@class ELEnvelopeProbabilityGenerator;

@interface ELPlayer : NSObject <ELData> {
  ElysiumDocument     *document;        // Cocoa NSDocument subclass hosting this player
  ELHarmonicTable     *harmonicTable;   // Represents the structure of notes to be played
  NSMutableArray      *layers;          // Each layer is an "instrument"
  NSMutableDictionary *oscillators;     // Generate random & semi-random "shaped" values
  ELConfig            *config;          // Top-level configuration, inherited by layers
  BOOL                isRunning;        // The player is active
  ELMIDIController    *midiController;  // Our interface to CoreMIDI
  int                 timerResolution;  
  UInt64              startTime;
  
  ELIntegerKnob       *tempoKnob;
}

@property (readonly) ELConfig *config;
@property (readonly) UInt64 startTime;
@property (readonly) ELHarmonicTable *harmonicTable;
@property (readonly) BOOL isRunning;

@property (readonly) ELIntegerKnob *tempoKnob;

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

- (void)toggleNoteDisplay;

// - (void)run;
// - (void)runOnce;
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
