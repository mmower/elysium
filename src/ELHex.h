//
//  ELHex.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <HoneycombView/LMHexCell.h>

@class ELLayer;
@class ELNote;
@class ELTool;
@class ELPlayhead;

@interface ELHex : LMHexCell {
  ELLayer         *layer;
  ELNote          *note;
  ELHex           *neighbours[6];
  NSMutableArray  *tools;
  NSMutableArray  *playheads;
}

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note column:(int)col row:(int)row;

- (ELNote *)note;

- (ELHex *)neighbour:(Direction)direction;

- (void)connectNeighbour:(ELHex *)hex direction:(Direction)direction;

- (void)addTool:(ELTool *)tool;
- (NSArray *)tools;
- (NSArray *)toolsOfType:(NSString *)type;
- (NSArray *)toolsExceptType:(NSString *)type;

- (void)playheadEntering:(ELPlayhead *)playhead;
- (void)playheadLeaving:(ELPlayhead *)playhead;

- (void)drawText:(NSString *)text;

@end
