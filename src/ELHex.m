//
//  ELHex.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import <HoneycombView/LMHoneycombView.h>

#import "ELHex.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ELTool.h"
#import "ELPlayhead.h"

@implementation ELHex

- (id)initWithLayer:(ELLayer *)_layer note:(ELNote *)_note column:(int)_col row:(int)_row {
  if( self = [super initWithColumn:_col row:_row] ) {
    layer     = _layer;
    note      = _note;
    tools     = [[NSMutableArray alloc] init];
    playheads = [[NSMutableArray alloc] init];
  }
  
  return self;
}

// Private method for connecting hexes without setting the inverse
- (void)connectToHex:(ELHex *)_hex direction:(Direction)_direction {
  neighbours[_direction] = _hex;
}

- (void)connectNeighbour:(ELHex *)_hex direction:(Direction)_direction {
  [self connectToHex:_hex direction:_direction];
  [_hex connectToHex:self direction:INVERSE_DIRECTION(_direction)];
}

- (ELNote *)note {
  return note;
}

- (ELHex *)neighbour:(Direction)_direction {
  return neighbours[_direction];
}

- (void)addTool:(ELTool *)_tool {
  [tools addObject:_tool];
  [_tool addedToLayer:layer atPosition:self];
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

- (NSString *)description {
  return [NSString stringWithFormat:@"(%d,%d)",col,row];
}

// Playheads

- (void)playheadEntering:(ELPlayhead *)_playhead {
  NSLog( @"Playhead %@ entering %@", _playhead, self );
  [playheads addObject:_playhead];
}

- (void)playheadLeaving:(ELPlayhead *)_playhead {
  NSLog( @"Playhead %@ leaving %@", _playhead, self );
  [playheads removeObject:_playhead];
}

// Drawing

- (void)drawNoteName {
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [attributes setObject:[NSColor whiteColor]
                 forKey:NSForegroundColorAttributeName];
  
  NSSize strSize = [[note name] sizeWithAttributes:attributes];
  
  NSPoint strOrigin;
  strOrigin.x = [path bounds].origin.x + ( [path bounds].size.width - strSize.width ) / 2;
  strOrigin.y = [path bounds].origin.y + ( [path bounds].size.height - strSize.height ) / 2;
  
  [[note name] drawAtPoint:strOrigin withAttributes:attributes];
}

- (void)drawOnHoneycombView:(LMHoneycombView *)_view withAttributes:(NSMutableDictionary *)_attributes {
  if( [playheads count] > 0 ) {
    NSLog( @"Playheads at %@", self );
    _attributes = [_attributes mutableCopy];
    [_attributes setObject:[NSColor redColor] forKey:LMHoneycombViewDefaultColor];
  }
  
  [super drawOnHoneycombView:_view withAttributes:_attributes];
}

@end
