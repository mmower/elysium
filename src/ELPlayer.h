//
//  ELPlayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELNote;
@class ELLayer;
@class ELTimer;
@class ELConfig;
@class ELHarmonicTable;
@class ELMIDIController;
@class ElysiumDocument;

@interface ELPlayer : NSObject {
  ElysiumDocument   *document;
  ELHarmonicTable   *harmonicTable;
  NSMutableArray    *layers;
  ELConfig          *config;
  NSThread          *thread;
  BOOL              running;
  ELTimer           *timer;
  ELMIDIController  *midiController;
  int               beatCount;
  int               timerResolution;
  UInt64            startTime;
}

- (int)beatCount;
- (UInt64)startTime;
- (ELHarmonicTable *)harmonicTable;
- (BOOL)isRunning;

- (void)setMIDIController:(ELMIDIController *)midiController;
- (void)setDocument:(ElysiumDocument *)document;

- (void)start;
- (void)stop;
- (void)playNote:(ELNote *)note channel:(int)channel velocity:(int)velocity duration:(float)duration;

- (void)addLayer;
- (ELLayer *)createLayer:(int)channel;
- (ELLayer *)firstLayer;

@end
