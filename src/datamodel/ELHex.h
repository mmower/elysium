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

@class ELStartTool;
@class ELBeatTool;
@class ELRicochetTool;
@class ELSinkTool;
@class ELSplitterTool;
@class ELRotorTool;

@interface ELHex : LMHexCell <ELXmlData> {
  ELLayer             *layer;
  ELNote              *note;
  ELHex               *neighbours[6];
  NSMutableArray      *tools;
  NSMutableArray      *playheads;
  
  ELStartTool         *generateTool;
  ELBeatTool          *noteTool;
  ELRicochetTool      *reboundTool;
  ELSinkTool          *absorbTool;
  ELSplitterTool      *splitTool;
  ELRotorTool         *spinTool;
}

@property (readonly) ELLayer *layer;
@property (readonly) ELNote *note;

@property ELStartTool *generateTool;
@property ELBeatTool *noteTool;
@property ELRicochetTool *reboundTool;
@property ELSinkTool *absorbTool;
@property ELSplitterTool *splitTool;
@property ELRotorTool *spinTool;

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

// Connections to other hexes

- (ELHex *)neighbour:(Direction)direction;
- (void)connectNeighbour:(ELHex *)hex direction:(Direction)direction;

// Tool management

- (BOOL)shouldBeSaved;

- (void)addTool:(ELTool *)tool;
- (void)removeTool:(ELTool *)tool;
- (void)removeAllTools;

- (NSArray *)tools;
- (NSArray *)toolsExceptType:(NSString *)type;

// Playhead management

- (void)playheadEntering:(ELPlayhead *)playhead;
- (void)playheadLeaving:(ELPlayhead *)playhead;

// Custom drawing for hexes

- (void)drawTriangleInDirection:(Direction)direction withAttributes:(NSDictionary *)attributes;
- (void)drawText:(NSString *)text  withAttributes:(NSMutableDictionary *)attributes;

@end
