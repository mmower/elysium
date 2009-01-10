//
//  ELHex.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

@interface ELHex : LMHexCell <ELXmlData,ELTaggable> {
  ELLayer             *layer;
  ELNote              *note;
  ELHex               *neighbours[6];
  NSMutableArray      *tools;
  NSMutableArray      *playheads;
  
  NSString            *scriptingTag;
  
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

- (void)addToolWithTag:(int)toolTag;
- (void)addTool:(ELTool *)tool;
- (void)removeTool:(ELTool *)tool;
- (void)removeAllTools;

// Actions for tool management
- (IBAction)clearTools:(id)sender;
- (IBAction)toggleGenerateToken:(id)sender;
- (IBAction)addGenerateTool:(id)sender;
- (IBAction)removeGenerateTool:(id)sender;
- (IBAction)toggleNoteToken:(id)sender;
- (IBAction)addNoteTool:(id)sender;
- (IBAction)removeNoteTool:(id)sender;
- (IBAction)toggleReboundToken:(id)sender;
- (IBAction)addReboundTool:(id)sender;
- (IBAction)removeReboundTool:(id)sender;
- (IBAction)toggleAbsorbToken:(id)sender;
- (IBAction)addAbsorbTool:(id)sender;
- (IBAction)removeAbsorbTool:(id)sender;
- (IBAction)toggleSplitToken:(id)sender;
- (IBAction)addSplitTool:(id)sender;
- (IBAction)removeSplitTool:(id)sender;
- (IBAction)toggleSpinToken:(id)sender;
- (IBAction)addSpinTool:(id)sender;
- (IBAction)removeSpinTool:(id)sender;

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
- (NSMenuItem *)toolMenuItem:(NSString *)name present:(BOOL)present selector:(SEL)selector;
- (void)makeCurrentSelection;

@end
