//
//  ELHex.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELLayer;
@class ELNote;
@class ELTool;

@interface ELHex : NSObject {
  ELLayer         *layer;
  ELNote          *note;
  int             col;
  int             row;
  ELHex           *neighbours[6];
  NSMutableArray  *tools;
}

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note col:(int)col row:(int)row;

- (ELNote *)note;

- (ELHex *)neighbour:(Direction)direction;

- (void)connectNeighbour:(ELHex *)hex direction:(Direction)direction;

- (void)addTool:(ELTool *)tool;
- (NSArray *)tools;
- (NSArray *)toolsOfType:(NSString *)type;
- (NSArray *)toolsExceptType:(NSString *)type;

@end
