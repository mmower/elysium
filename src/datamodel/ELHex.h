//
//  ELHex.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELData.h"
#import <HoneycombView/LMHexCell.h>

@class ELLayer;
@class ELNote;
@class ELTool;
@class ELPlayhead;

@interface ELHex : LMHexCell <ELData> {
  ELLayer             *layer;
  ELNote              *note;
  ELHex               *neighbours[6];
  NSMutableDictionary *tools;
  NSMutableArray      *playheads;
}

@property (readonly) ELLayer *layer;
@property (readonly) ELNote *note;

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

// Connections to other hexes

- (ELHex *)neighbour:(Direction)direction;
- (void)connectNeighbour:(ELHex *)hex direction:(Direction)direction;

// Tool management

- (void)addTool:(ELTool *)tool;
- (void)removeTool:(NSString *)type;
- (void)removeAllTools;

- (BOOL)hasToolOfType:(NSString *)type;
- (ELTool *)toolOfType:(NSString *)type;
- (NSArray *)tools;
- (NSArray *)toolsExceptType:(NSString *)type;

// Playhead management

- (void)playheadEntering:(ELPlayhead *)playhead;
- (void)playheadLeaving:(ELPlayhead *)playhead;

// Custom drawing for hexes

- (void)drawTriangleInDirection:(Direction)direction withAttributes:(NSDictionary *)attributes;
- (void)drawText:(NSString *)text;

@end
