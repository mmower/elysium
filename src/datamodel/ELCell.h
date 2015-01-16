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

@interface ELCell : LMHexCell <ELXmlData, ELTaggable> {
    ELLayer *_layer;
    ELNote *_note;
    ELCell *_neighbours[6];
    NSMutableArray *_playheads;
    
    NSString *_scriptingTag;
    
    BOOL _dirty;
    
    NSMutableDictionary *_tokens;
    ELGenerateToken *_generateToken;
    ELNoteToken *_noteToken;
    ELReboundToken *_reboundToken;
    ELAbsorbToken *_absorbToken;
    ELSplitToken *_splitToken;
    ELSpinToken *_spinToken;
    ELSkipToken *_skipToken;
    
    BOOL _playheadEntered;
}

@property (nonatomic, readonly) ELLayer *layer;
@property (nonatomic, readonly) ELNote *note;
@property (nonatomic, readonly) NSMutableArray *playheads;

@property (nonatomic, readonly)  NSMutableDictionary *tokens;

@property (nonatomic) BOOL dirty;

@property (nonatomic, strong) ELGenerateToken *generateToken;
@property (nonatomic, strong)  ELNoteToken *noteToken;
@property (nonatomic, strong)  ELReboundToken *reboundToken;
@property (nonatomic, strong)  ELAbsorbToken *absorbToken;
@property (nonatomic, strong)  ELSplitToken *splitToken;
@property (nonatomic, strong)  ELSpinToken *spinToken;
@property (nonatomic, strong)  ELSkipToken *skipToken;

@property  (nonatomic) BOOL playheadEntered;

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

// Connections to other cells

- (ELCell *)neighbour:(Direction)direction;
- (void)connectNeighbour:(ELCell *)cell direction:(Direction)direction;
- (ELNoteGroup *)triad:(int)triad;
- (NSString *)noteName;

// Token management

- (void)needsDisplay;

- (BOOL)shouldBeSaved;

- (void)start;

- (void)run:(ELPlayhead *)playhead;

- (void)removeAllTokens;
- (void)removeAllTokensWithUndo;


- (BOOL)hasTokenWithIdentifier:(NSString *)identifier;

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
- (void)drawText:(NSString *)text withAttributes:(NSMutableDictionary *)attributes;

// Menu support
- (NSMenuItem *)tokenMenuItem:(NSString *)name present:(BOOL)present selector:(SEL)selector;
- (void)makeCurrentSelection;

@end
