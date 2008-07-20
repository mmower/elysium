//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"
#import "ELHex.h"
#import "ELLayer.h"

@implementation ELLayer

- (id)initWithHarmonicTable:(ELHarmonicTable *)_harmonicTable instrument:(int)_instrument config:(NSMutableDictionary *)_config {
  if( self = [super init] ) {
    harmonicTable = _harmonicTable;
    instrument = _instrument;
    config = _config;
    hexes = [[NSMutableArray alloc] initWithCapacity:[harmonicTable size]];
    
    for( int col = 0; col < [harmonicTable cols]; col++ ) {
      for( int row = 0; row < [harmonicTable rows]; row++ ) {
        [hexes insertObject:[[ELHex alloc] initWithLayer:self
                                                    note:[harmonicTable noteAtCol:col row:row]
                                                     col:col
                                                     row:row] atIndex:COL_ROW_OFFSET(col,row)];
      }
    }
  }
  
  return self;
}

- (void)run {
  
}

- (void)stop {
  
}

@end
