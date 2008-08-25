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

- (void)setMIDIController:(ELMIDIController *)midiController;
- (void)setDocument:(ElysiumDocument *)document;

- (void)start;
- (void)stop;
- (void)playNoteInBackground:(NSDictionary *)noteInfo;
- (void)playNote:(ELNote *)note channel:(int)channel velocity:(int)velocity duration:(float)duration;

// Layer management
- (ELLayer *)layerForChannel:(int)channel;

@end
