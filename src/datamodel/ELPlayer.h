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
@class ELHarmonicTable;
@class ELMIDIController;
@class ElysiumDocument;
@class ELEnvelopeProbabilityGenerator;

@interface ELPlayer : NSObject <ELXmlData> {
  ElysiumDocument     *document;        // Cocoa NSDocument subclass hosting this player
  ELHarmonicTable     *harmonicTable;   // Represents the structure of notes to be played
  NSMutableArray      *layers;          // Each layer is an "instrument"
  NSMutableArray      *filters;         // Generate random & semi-random "shaped" values
  BOOL                isRunning;        // The player is active
  ELMIDIController    *midiController;  // Our interface to CoreMIDI
  int                 timerResolution;  
  UInt64              startTime;
  
  int                 nextLayerNumber;
  BOOL                showNotes;
  
  NSMutableDictionary *scripts;
  
  ELIntegerKnob       *tempoKnob;
  ELIntegerKnob       *timeToLiveKnob;
  ELIntegerKnob       *pulseCountKnob;
  ELIntegerKnob       *velocityKnob;
  ELFloatKnob         *durationKnob;
  ELIntegerKnob       *transposeKnob;
}

@property (readonly) UInt64 startTime;
@property (readonly) ELHarmonicTable *harmonicTable;
@property (readonly) BOOL isRunning;
@property BOOL showNotes;
@property (readonly) NSArray *filters;

@property ELMIDIController *midiController;
@property ElysiumDocument *document;
@property (readonly) NSMutableDictionary *scripts;

@property (readonly) ELIntegerKnob *tempoKnob;
@property (readonly) ELIntegerKnob *timeToLiveKnob;
@property (readonly) ELIntegerKnob *pulseCountKnob;
@property (readonly) ELIntegerKnob *velocityKnob;
@property (readonly) ELFloatKnob   *durationKnob;
@property (readonly) ELIntegerKnob *transposeKnob;

- (id)initWithDocument:(ElysiumDocument *)document midiController:(ELMIDIController *)_midiController_;
- (id)initWithDocument:(ElysiumDocument *)document midiController:(ELMIDIController *)_midiController_ createDefaultLayer:(BOOL)createDefaultLayer;

- (void)toggleNoteDisplay;

- (void)start;
- (void)stop;
- (void)reset;

- (void)clearAll;

- (void)playNote:(int)note channel:(int)channel velocity:(int)velocity duration:(float)duration;
- (void)scheduleNote:(int)note channel:(int)channel velocity:(int)velocity on:(UInt64)on off:(UInt64)off;

// Drawing support

- (void)needsDisplay;

// Oscillator management
- (NSArray *)filterFunctions;

// Layer management
- (ELLayer *)createLayer;
- (void)addLayer:(ELLayer *)layer;
- (int)layerCount;
- (void)removeLayers;
- (NSArray *)layers;
- (ELLayer *)layer:(int)index;

@end
