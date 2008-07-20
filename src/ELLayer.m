//
//  ELLayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELLayer.h"

@implementation ELLayer

- (id)initWithHarmonicTable:(ELHarmonicTable *)_harmonicTable instrument:(int)_instrument config:(NSMutableDictionary *)_config {
  if( self = [super init] ) {
    harmonicTable = _harmonicTable;
    instrument = _instrument;
    config = _config;
  }
  
  return self;
}

@end
