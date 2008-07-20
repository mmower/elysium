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
@class ELConfig;
@class ELHarmonicTable;

@interface ELPlayer : NSObject {
  ELHarmonicTable   *harmonicTable;
  NSMutableArray    *layers;
  ELConfig          *config;
  NSThread          *thread;
}

- (ELHarmonicTable *)harmonicTable;

- (void)playNote:(ELNote *)note channel:(int)channel velocity:(int)velocity duration:(float)duration;

- (void)addLayer;
- (ELLayer *)createLayer:(int)channel;

- (void)start;
- (void)stop;

@end
