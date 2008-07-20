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

@interface ELHex : NSObject {
  ELLayer         *layer;
  ELNote          *note;
  int             col;
  int             row;
  NSMutableArray  *markers;
}

- (id)initWithLayer:(ELLayer *)layer note:(ELNote *)note col:(int)col row:(int)row;

- (ELHex *)neighbour:(Direction)direction;
- (ELHex *)neighbourNorth;
- (ELHex *)neighbourNorthEast;
- (ELHex *)neighbourSouthEast;
- (ELHex *)neighbourSouth;
- (ELHex *)neighbourSouthWest;
- (ELHex *)neighbourNorthWest;

@end
