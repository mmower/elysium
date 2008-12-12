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
@class ELNoteGroup;

@class ELGenerateTool;
@class ELNoteTool;
@class ELReboundTool;
@class ELAbsorbTool;
@class ELSplitTool;
@class ELSpinTool;

@interface ELHex : LMHexCell <ELXmlData> {
  ELLayer             *layer;
  ELNote              *note;
  ELHex               *neighbours[6];
  NSMutableArray      *tools;
  NSMutableArray      *playheads;
  
  ELGenerateTool      *generateTool;
  ELNoteTool          *noteTool;
  ELReboundTool       *reboundTool;
  ELAbsorbTool        *absorbTool;
  ELSplitTool         *splitTool;
  ELSpinTool          *spinTool;
}

@property (readonly) ELLayer *layer;
@property (readonly) ELNote *note;

@property ELGenerateTool  *generateTool;
@property ELNoteTool      *noteTool;
@property ELReboundTool   *reboundTool;
@property ELAbsorbTool    *absorbTool;
@property ELSplitTool     *splitTool;
@property ELSpinTool      *spinTool;

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

// Connections to other hexes

- (ELHex *)neighbour:(Direction)direction;
- (void)connectNeighbour:(ELHex *)hex direction:(Direction)direction;
- (ELNoteGroup *)triad:(int)triad;

// Tool management

- (BOOL)shouldBeSaved;

- (void)start;

- (void)run:(ELPlayhead *)playhead;

- (void)addTool:(ELTool *)tool;
- (void)removeTool:(ELTool *)tool;
- (void)removeAllTools;

// Actions for tool management
- (IBAction)clearTools;
- (IBAction)addGenerateTool;
- (IBAction)removeGenerateTool;
- (IBAction)addNoteTool;
- (IBAction)removeNoteTool;
- (IBAction)addReboundTool;
- (IBAction)removeReboundTool;
- (IBAction)addAbsorbTool;
- (IBAction)removeAbsorbTool;
- (IBAction)addSplitTool;
- (IBAction)removeSplitTool;
- (IBAction)addSpinTool;
- (IBAction)removeSpinTool;

- (NSArray *)tools;
- (NSArray *)toolsExceptType:(NSString *)type;

- (void)copyToolsFrom:(ELHex *)hex;

// Playhead management

- (void)playheadEntering:(ELPlayhead *)playhead;
- (void)playheadLeaving:(ELPlayhead *)playhead;

// Custom drawing for hexes

- (void)drawTriangleInDirection:(Direction)direction withAttributes:(NSDictionary *)attributes;
- (void)drawText:(NSString *)text  withAttributes:(NSMutableDictionary *)attributes;

// Menu support
- (NSMenuItem *)toolMenuItem:(NSString *)name present:(BOOL)present addSelector:(SEL)addSelector removeSelector:(SEL)removeSelector;
- (void)makeCurrentSelection;

@end
