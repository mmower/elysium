//
//  ELNoteGroup.h
//  Elysium
//
//  Created by Matt Mower on 18/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELPlayable.h"

@class ELNote;

@interface ELNoteGroup : ELPlayable {
  NSMutableArray *notes;
}

- (id)initWithNote:(ELNote *)note;
- (void)addNote:(ELNote *)note;

@end
