//
//  ELHarmonicTable.h
//  Elysium
//
//  Created by Matt Mower on 19/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELNote.h"

@interface ELHarmonicTable : NSObject {
  NSMutableArray	*_entries;
}

- (ELNote *)noteAtCol:(int)col row:(int)row;

- (int)size;
- (int)cols;
- (int)rows;

@end
