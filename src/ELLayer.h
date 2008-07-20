//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELPlayer;
@class ELPlayhead;

@interface ELLayer : NSObject {
  ELPlayer            *player;
  NSMutableArray      *hexes;
  NSMutableDictionary *config;
  NSMutableArray      *playheads;
  int                 beatCount;
  
  // Configuration items
  int                 instrument;
  int                 pulseCount;
}

- (id)initWithPlayer:(ELPlayer *)player config:(NSMutableDictionary *)config;

- (ELHex *)hexAtCol:(int)col row:(int)row;

- (void)run;
- (void)stop;

- (void)removeAllPlayheads;
- (void)addPlayhead:(ELPlayhead *)playhead;
- (void)pulse;

- (void)configureHexes;

@end
