//
//  ELHex.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELHex.h"

#import "ELNote.h"

@implementation ELHex

- (id)initWithLayer:(ELLayer *)_layer note:(ELNote *)_note col:(int)_col row:(int)_row {
  if( self = [super init] ) {
    layer = _layer;
    note = _note;
    col = _col;
    row = _row;
  }
  
  return self;
}

@end
