//
//  ELPlayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELMIDITrigger.h"
#import "ELMIDIController.h"

@class ELNote;
@class ELLayer;
@class ELTimer;
@class ELHarmonicTable;
@class ELMIDIController;
@class ELMIDINoteMessage;
@class ElysiumDocument;
@class ELScriptPackage;
@class ELEnvelopeProbabilityGenerator;

@interface ELPlayer : NSObject <ELXmlData,ELTaggable> {
  ElysiumDocument     *_document;        // Cocoa NSDocument subclass hosting this player
  ELHarmonicTable     *_harmonicTable;   // Represents the structure of notes to be played
  NSMutableArray      *_layers;          // Each layer is an "instrument"
  ELLayer             *_selectedLayer;
  BOOL                _running;          // The player is active
  ELMIDIController    *_midiController;  // Our interface to CoreMIDI
  // int                 _timerResolution;
  // UInt64              _startTime;
  
  int                 _nextLayerNumber;
  BOOL                _showNotes;
  BOOL                _showOctaves;
  BOOL                _showKey;
  BOOL                _performanceMode;
  BOOL                _dirty;
  
  NSString            *_scriptingTag;
  NSMutableDictionary *_scripts;
  NSMutableArray      *_triggers;        // ELMIDITrigger objects
  NSThread            *_triggerThread;
  
  NSThread            *_oscillatorThread;
  NSMutableArray      *_activeOscillators;
  
  ELScriptPackage     *_pkg;
  
  ELDial              *_tempoDial;
  ELDial              *_barLengthDial;
  ELDial              *_timeToLiveDial;
  ELDial              *_pulseEveryDial;
  ELDial              *_velocityDial;
  ELDial              *_emphasisDial;
  ELDial              *_tempoSyncDial;
  ELDial              *_noteLengthDial;
  ELDial              *_transposeDial;
}

// @property (readonly)  UInt64              startTime;
@property (readonly)  ELHarmonicTable     *harmonicTable;
@property (readonly)  NSMutableArray      *layers;
@property             BOOL                running;
@property             BOOL                showNotes;
@property             BOOL                showOctaves;
@property             BOOL                showKey;
@property             BOOL                performanceMode;
@property             BOOL                dirty;

@property             ELLayer             *selectedLayer;

@property             ElysiumDocument     *document;
@property (readonly)  NSMutableDictionary *scripts;
@property (readonly)  NSMutableArray      *triggers;
@property (readonly)  ELScriptPackage     *pkg;

@property (readonly)  NSMutableArray      *activeOscillators;

@property             ELDial              *tempoDial;
@property             ELDial              *barLengthDial;
@property             ELDial              *timeToLiveDial;
@property             ELDial              *pulseEveryDial;
@property             ELDial              *velocityDial;
@property             ELDial              *emphasisDial;
@property             ELDial              *tempoSyncDial;
@property             ELDial              *noteLengthDial;
@property             ELDial              *transposeDial;

- (id)initWithDocument:(ElysiumDocument *)document;
- (id)initWithDocument:(ElysiumDocument *)document createDefaultLayer:(BOOL)shouldCreateDefaultLayer;

+ (ELDial *)defaultTempoDial;
+ (ELDial *)defaultBarLengthDial;
+ (ELDial *)defaultTimeToLiveDial;
+ (ELDial *)defaultPulseEveryDial;
+ (ELDial *)defaultTriggerModeDial;
+ (ELDial *)defaultVelocityDial;
+ (ELDial *)defaultEmphasisDial;
+ (ELDial *)defaultTempoSyncDial;
+ (ELDial *)defaultNoteLengthDial;
+ (ELDial *)defaultTransposeDial;
+ (ELDial *)defaultEnabledDial;
+ (ELDial *)defaultPDial;
+ (ELDial *)defaultGateDial;
+ (ELDial *)defaultDirectionDial;
+ (ELDial *)defaultOffsetDial;
+ (ELDial *)defaultTriadDial;
+ (ELDial *)defaultGhostsDial;
+ (ELDial *)defaultOverrideDial;
+ (ELDial *)defaultBounceBackDial;
+ (ELDial *)defaultClockWiseDial;
+ (ELDial *)defaultSteppingDial;
+ (ELDial *)defaultSkipCountDial;

- (void)toggleNoteDisplay;

- (void)start:(id)sender;
- (void)stop:(id)sender;
- (void)reset;

- (void)clearAll;

// Drawing support

- (void)needsDisplay;

// Layer management
- (ELLayer *)createLayer;
- (void)addLayer:(ELLayer *)layer;
- (int)layerCount;
- (void)removeLayers;
- (ELLayer *)layer:(int)index;

// MIDI Trigger support
- (void)processMIDIControlMessage:(NSNotification *)notification;
- (void)handleMIDIControlMessage:(ELMIDIControlMessage *)message;
- (void)processMIDINoteMessage:(NSNotification *)notification;
- (void)handleMIDINoteMessage:(ELMIDINoteMessage *)message;

// Script support
- (void)runWillStartScript;
- (void)runDidStartScript;
- (void)runWillStopScript;
- (void)runDidStopScript;

- (ELScript *)callbackTemplate;

@end
