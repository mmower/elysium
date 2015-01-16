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

@class ELKey;
@class ELCell;
@class ELNote;
@class ELPlayer;
@class ELPlayhead;
@class ELGenerateToken;
@class ELMIDINoteMessage;
@class ELLayerWindowController;

@interface ELLayer : NSObject <LMHoneycombMatrix, ELXmlData, ELTaggable> {
    id _delegate;                           // This will be the view representing us in the UI
    
    ELPlayer *_player;                      // The player we belong to
    NSMutableArray *_cells;                 // The cells that make up the lattice structure of the layer
    NSMutableArray *_playheads;             // Array of playheads active on our surface
    NSMutableArray *_playheadQueue;         // Array of playheads to be queued onto the layer in the next beat
    NSMutableArray *_generators;            // Array of playhead generator tokens
    int _beatCount;                         // Current beat number
    
    UInt64 _timeBase;                       // Our MIDI timebase, time of next beat can be calculated
    // from this, the tempo, and the beatcount. This should be
    // reset if the tempo is ever reset.
    
    NSThread *_runner;                      // The thread that runs this layer
    BOOL _isRunning;                        // Whether or not this layer is running
    
    BOOL _dirty;                            // Layer or cell has been updated
    
    NSMutableDictionary *_scripts;
    // NSString            *_scriptingTag;
    
    NSMutableArray *_receivedNotes;
    
    ELLayerWindowController *_windowController;
    
    NSString *_layerId;
    
    ELKey *_key;                         // If this layer is in a musical key
    
    ELCell *_selectedCell;
    
    ELDial *_enabledDial;
    ELDial *_channelDial;
    ELDial *_tempoDial;
    ELDial *_barLengthDial;
    ELDial *_timeToLiveDial;
    ELDial *_pulseEveryDial;
    ELDial *_velocityDial;
    ELDial *_emphasisDial;
    ELDial *_tempoSyncDial;
    ELDial *_noteLengthDial;
    ELDial *_transposeDial;
}


+ (NSPredicate *)deadPlayheadFilter;


- (id)initWithPlayer:(ELPlayer *)player;
- (id)initWithPlayer:(ELPlayer *)player channel:(int)channel;


@property (nonatomic, strong) ELPlayer *player;
@property (nonatomic, assign) id delegate;

@property (nonatomic, strong)     NSString *layerId;
@property (nonatomic, strong) ELCell *selectedCell;
@property (nonatomic, strong) ELKey *key;
@property (nonatomic, readonly, strong) NSMutableArray *receivedNotes;
@property (nonatomic, readonly)  BOOL isRunning;
@property (nonatomic) int beatCount;
@property (nonatomic) BOOL visible;
@property (nonatomic) BOOL dirty;

@property (nonatomic, strong) ELLayerWindowController *windowController;
@property CGFloat alphaValue;

@property (nonatomic, strong)  ELDial *enabledDial;
@property (nonatomic, strong)  ELDial *channelDial;
@property (nonatomic, strong)  ELDial *tempoDial;
@property (nonatomic, strong)  ELDial *barLengthDial;
@property (nonatomic, strong)  ELDial *timeToLiveDial;
@property (nonatomic, strong)  ELDial *pulseEveryDial;
@property (nonatomic, strong)  ELDial *velocityDial;
@property (nonatomic, strong)  ELDial *emphasisDial;
@property (nonatomic, strong)  ELDial *tempoSyncDial;
@property (nonatomic, strong)  ELDial *noteLengthDial;
@property (nonatomic, strong)  ELDial *transposeDial;

@property (nonatomic, strong) NSMutableDictionary *scripts;

- (ELPlayer *)player;
- (ELCell *)cellAtColumn:(int)col row:(int)row;

// Dynamic Configuration

- (int)timerResolution;

- (void)addGenerator:(ELGenerateToken *)generator;
- (void)removeGenerator:(ELGenerateToken *)generator;

- (void)run;
- (void)stop;
- (void)reset;

- (void)clear;

- (void)handleMIDINoteMessage:(ELMIDINoteMessage *)message;
- (BOOL)receivedMIDINote:(ELNote *)note;

- (BOOL)firstBeatInBar;

- (void)removeAllPlayheads;
- (void)queuePlayhead:(ELPlayhead *)playhead;
- (void)addQueuedPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureCells;

- (void)needsDisplay;

- (void)runWillRunScript;
- (void)runDidRunScript;
- (ELScript *)callbackTemplate;

@end
