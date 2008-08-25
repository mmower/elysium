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
    tools     = [[NSMutableDictionary alloc] init];
    playheads = [[NSMutableArray alloc] init];
    
    [self connectNeighbour:nil direction:N];
    [self connectNeighbour:nil direction:NE];
    [self connectNeighbour:nil direction:SE];
    [self connectNeighbour:nil direction:S];
    [self connectNeighbour:nil direction:SW];
    [self connectNeighbour:nil direction:NW];
  }
  
  return self;
}

// Private method for connecting hexes without setting the inverse
- (void)connectToHex:(ELHex *)_hex direction:(Direction)_direction {
  neighbours[_direction] = _hex;
}

- (void)connectNeighbour:(ELHex *)_hex direction:(Direction)_direction {
  [self connectToHex:_hex direction:_direction];
  // [_hex connectToHex:self direction:INVERSE_DIRECTION(_direction)];
}

- (ELNote *)note {
  return note;
}

- (ELHex *)neighbour:(Direction)_direction {
  return neighbours[_direction];
}

- (void)addTool:(ELTool *)_tool {
  [tools setObject:_tool forKey:[_tool toolType]];
  [_tool addedToLayer:layer atPosition:self];
}

- (void)removeTool:(NSString *)_type {
  ELTool *tool = [self toolOfType:_type];
  [tool removedFromLayer:layer];
  [tools removeObjectForKey:_type];
}

- (NSArray *)tools {
  return [tools allValues];
}

- (BOOL)hasStartTool {
  return [self toolOfType:@"start"] != nil;
}

- (BOOL)hasToolOfType:(NSString *)type {
  return [self toolOfType:type] != nil;
}

- (ELTool *)toolOfType:(NSString *)_type {
  return [tools objectForKey:_type];
}

- (NSArray *)toolsExceptType:(NSString *)_type {
  NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"toolType != %@",_type];
  return [[tools allValues] filteredArrayUsingPredicate:typePredicate];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"Pos(%d,%d):%@",col,row,note];
}

// Playheads

- (void)playheadEntering:(ELPlayhead *)_playhead {
  [playheads addObject:_playhead];
}

- (void)playheadLeaving:(ELPlayhead *)_playhead {
  [playheads removeObject:_playhead];
}

// Drawing

- (void)drawText:(NSString *)_text {
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSFont fontWithName:@"Helvetica" size:9]
                 forKey:NSFontAttributeName];
  [attributes setObject:[NSColor whiteColor]
                 forKey:NSForegroundColorAttributeName];
  
  NSSize strSize = [_text sizeWithAttributes:attributes];
  
  NSPoint strOrigin;
  strOrigin.x = [path bounds].origin.x + ( [path bounds].size.width - strSize.width ) / 2;
  strOrigin.y = [path bounds].origin.y + ( [path bounds].size.height - strSize.height ) / 2;
  
  [_text drawAtPoint:strOrigin withAttributes:attributes];
}

- (void)drawPlayheadSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawStartSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawBeatSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawRicochetSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawSinkSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawSplitterSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawRotorSymbolWithAttributes:(NSMutableDictionary *)_attributes_ {
  
}

- (void)drawOnHoneycombView:(LMHoneycombView *)_view_ withAttributes:(NSMutableDictionary *)_attributes_ {
  [super drawOnHoneycombView:_view_ withAttributes:_attributes_];
  
  if( [playheads count] > 0 ) {
    [self drawPlayheadSymbolWithAttributes:_attributes_];
  }
  
  if( [self toolOfType:@"start"] ) {
    [self drawStartSymbolWithAttributes:_attributes_];
  }
  if( [self toolOfType:@"beat"] ) {
    [self drawBeatSymbolWithAttributes:_attributes_];
  }
}

// Implementing the ELData protocol

- (NSXMLElement *)asXMLData {
  NSXMLElement *cellElement = [NSXMLNode elementWithName:@"cell"];
  NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
  [attributes setObject:[NSNumber numberWithInt:col] forKey:@"col"];
  [attributes setObject:[NSNumber numberWithInt:row] forKey:@"row"];
  [cellElement setAttributesAsDictionary:attributes];
  
  for( ELTool *tool in [self tools] ) {
    [cellElement addChild:[tool asXMLData]];
  }
  
  return cellElement;
}

- (BOOL)fromXMLData:(NSXMLElement *)_xml_ {
  for( NSXMLNode *markerNode in [_xml_ nodesForXPath:@"marker" error:nil] ) {
    ELTool *tool = [ELTool fromXMLData:(NSXMLElement *)markerNode];
    if( !tool ) {
      NSLog( @"Unable to load tool configuration!" );
      return NO;
    }
    
    [self addTool:tool];
  }
  
  return YES;
}

@end
