//
//  ELCell.h
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
@class ELToken;
@class ELPlayhead;
@class ELNoteGroup;

@class ELGenerateToken;
@class ELNoteToken;
@class ELReboundToken;
@class ELAbsorbToken;
@class ELSplitToken;
@class ELSpinToken;
@class ELSkipToken;

@interface ELCell : LMHexCell <ELXmlData,ELTaggable> {
  ELLayer             *layer;
  ELNote              *note;
  ELCell              *neighbours[6];
  NSMutableArray      *playheads;
  
  NSString            *scriptingTag;
  
  NSMutableDictionary *tokens;
  ELGenerateToken     *generateToken;
  ELNoteToken         *noteToken;
  ELReboundToken      *reboundToken;
  ELAbsorbToken       *absorbToken;
  ELSplitToken        *splitToken;
  ELSpinToken         *spinToken;
  ELSkipToken         *skipToken;
}

@property (readonly) ELLayer *layer;
@property (readonly) ELNote *note;

@property (readonly)  NSMutableDictionary *tokens;

@property             ELGenerateToken     *generateToken;
@property             ELNoteToken         *noteToken;
@property             ELReboundToken      *reboundToken;
@property             ELAbsorbToken       *absorbToken;
@property             ELSplitToken        *splitToken;
@property             ELSpinToken         *spinToken;
@property             ELSkipToken         *skipToken;

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

// Connections to other cells

- (ELCell *)neighbour:(Direction)direction;
- (void)connectNeighbour:(ELCell *)cell direction:(Direction)direction;
- (ELNoteGroup *)triad:(int)triad;

// Token management

- (void)needsDisplay;

- (BOOL)shouldBeSaved;

- (void)start;

- (void)run:(ELPlayhead *)playhead;

- (void)addToken:(ELToken *)token;
- (void)removeToken:(ELToken *)token;
- (void)removeAllTokens;

// Actions for Token management
- (IBAction)clearTokens:(id)sender;
- (IBAction)toggleGenerateToken:(id)sender;
- (IBAction)toggleNoteToken:(id)sender;
- (IBAction)toggleReboundToken:(id)sender;
- (IBAction)toggleAbsorbToken:(id)sender;
- (IBAction)toggleSplitToken:(id)sender;
- (IBAction)toggleSpinToken:(id)sender;
- (IBAction)toggleSkipToken:(id)sender;

- (void)copyTokensFrom:(ELCell *)cell;

// Playhead management

- (void)playheadEntering:(ELPlayhead *)playhead;
- (void)playheadLeaving:(ELPlayhead *)playhead;

// Custom drawing for cells

- (void)drawTriangleInDirection:(Direction)direction withAttributes:(NSDictionary *)attributes;
- (void)drawText:(NSString *)text  withAttributes:(NSMutableDictionary *)attributes;

// Menu support
- (NSMenuItem *)tokenMenuItem:(NSString *)name present:(BOOL)present selector:(SEL)selector;
- (void)makeCurrentSelection;

@end
