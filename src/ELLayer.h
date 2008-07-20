//
//  ELLayer.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELHarmonicTable.h"

@interface ELLayer : NSObject {
  ELHarmonicTable     *harmonicTable;
  NSMutableArray      *hexes;
  int                 instrument;
  NSMutableDictionary *config;
  NSMutableArray      *playheads;
}

- (id)initWithHarmonicTable:(ELHarmonicTable *)harmonicTable instrument:(int)instrument config:(NSMutableDictionary *)config;

- (ELHex *)hexAtCol:(int)col row:(int)row;

@end
