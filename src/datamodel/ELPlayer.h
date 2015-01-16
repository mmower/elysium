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
@class ELOscillatorController;
@class ELMIDINoteMessage;
@class ElysiumDocument;
@class ELScriptEngine;
@class ELScriptPackage;
@class ELEnvelopeProbabilityGenerator;

@interface ELPlayer : NSObject <ELXmlData, ELTaggable> {
    ElysiumDocument *_document;              // Cocoa NSDocument subclass hosting this player
    ELHarmonicTable *_harmonicTable;         // Represents the structure of notes to be played
    NSMutableArray *_layers;                 // Each layer is an "instrument"
    ELLayer *_selectedLayer;
    BOOL _running;                           // The player is active
    // ELMIDIController      *_midiController;  // Our interface to CoreMIDI
    ELOscillatorController *_oscillatorController;
    
    int _nextLayerNumber;
    BOOL _dirty;
    
    NSString *_scriptingTag;
    
    NSMutableArray *_triggers;               // ELMIDITrigger objects
    NSThread *_triggerThread;
    
    ELScriptEngine *_scriptEngine;
    
    ELScriptPackage *_pkg;
    
    ELDial *_tempoDial;
    ELDial *_barLengthDial;
    ELDial *_timeToLiveDial;
    ELDial *_pulseEveryDial;
    ELDial *_velocityDial;
    ELDial *_emphasisDial;
    ELDial *_tempoSyncDial;
    ELDial *_noteLengthDial;
    ELDial *_transposeDial;
    
    BOOL _loaded;
}

// @property (nonatomic,readonly)  UInt64              startTime;
@property (readonly, nonatomic, strong)  ELHarmonicTable *harmonicTable;
@property (readonly, nonatomic, strong)  NSMutableArray *layers;
@property (nonatomic) BOOL running;
@property (nonatomic) BOOL dirty;

@property (nonatomic, strong) ELLayer *selectedLayer;

@property (nonatomic, strong) ElysiumDocument *document;
@property (nonatomic, strong)  NSMutableDictionary *scripts;
@property (readonly, nonatomic, strong)  NSMutableArray *triggers;

@property (readonly, nonatomic, retain) ELScriptEngine *scriptEngine;
@property (readonly, nonatomic, strong)  ELScriptPackage *pkg;

@property (readonly, nonatomic, strong)  ELOscillatorController *oscillatorController;

// @property (nonatomic,readonly)  NSMutableArray      *activeOscillators;

@property (nonatomic, strong) ELDial *tempoDial;
@property (nonatomic, strong) ELDial *barLengthDial;
@property (nonatomic, strong) ELDial *timeToLiveDial;
@property (nonatomic, strong) ELDial *pulseEveryDial;
@property (nonatomic, strong) ELDial *velocityDial;
@property (nonatomic, strong) ELDial *emphasisDial;
@property (nonatomic, strong) ELDial *tempoSyncDial;
@property (nonatomic, strong) ELDial *noteLengthDial;
@property (nonatomic, strong) ELDial *transposeDial;

- (id)initWithDocument:(ElysiumDocument *)document;
- (id)initWithDocument:(ElysiumDocument *)document createDefaultLayer:(BOOL)shouldCreateDefaultLayer;

// - (void)toggleNoteDisplay;

- (NSUndoManager *)undoManager;

- (void)start:(id)sender;
- (void)stop:(id)sender;
- (void)reset;

- (void)clearAll;

// Drawing support

- (void)needsDisplay;

// Layer management
- (ELLayer *)createLayer;
- (ELLayer *)makeLayer;
- (void)addLayer:(ELLayer *)layer;
- (void)removeLayer:(ELLayer *)layer;
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
