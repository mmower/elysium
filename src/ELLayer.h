//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELHex;
@class ELHarmonicTable;

@interface ELLayer : NSObject {
  ELHarmonicTable     *harmonicTable;
  NSMutableArray      *hexes;
  NSMutableDictionary *config;
  NSMutableArray      *playheads;
  int                 beatCount;
  
  // Configuration items
  int                 instrument;
  int                 pulseCount;
}

- (id)initWithHarmonicTable:(ELHarmonicTable *)harmonicTable config:(NSMutableDictionary *)config;

- (ELHex *)hexAtCol:(int)col row:(int)row;

- (void)run;
- (void)stop;

- (void)removeAllPlayheads;
- (void)pulse;

- (void)configureHexes;

@end
