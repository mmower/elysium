//
//  ELHex.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELTool.h"

@implementation ELHex

- (id)initWithLayer:(ELLayer *)_layer note:(ELNote *)_note col:(int)_col row:(int)_row {
  if( self = [super init] ) {
    layer      = _layer;
    note       = _note;
    col        = _col;
    row        = _row;
    neighbours = [[NSMutableArray alloc] initWithCapacity:6];
    tools      = [[NSMutableArray alloc] init];
  }
  
  return self;
}

// Private method for connecting hexes without setting the inverse
- (void)connectToHex:(ELHex *)_hex direction:(Direction)_direction {
  [neighbours insertObject:_hex atIndex:_direction];
}

- (void)connectNeighbour:(ELHex *)_hex direction:(Direction)_direction {
  [self connectToHex:_hex direction:_direction];
  [_hex connectToHex:self direction:INVERSE_DIRECTION(_direction)];
}

- (ELHex *)neighbour:(Direction)direction {
  return [neighbours objectAtIndex:direction];
}

- (void)addTool:(ELTool *)_tool {
  [tools addObject:_tool];
}

- (NSArray *)tools {
  return [tools copy];
}

- (NSArray *)toolsOfType:(NSString *)_type {
  NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"type == %@",_type];
  return [tools filteredArrayUsingPredicate:typePredicate];
}

- (NSArray *)toolsExceptType:(NSString *)_type {
  NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"type != %@",_type];
  return [tools filteredArrayUsingPredicate:typePredicate];
}

@end
