/*
 *  Elysium.h
 *  Elysium
 *
 *  Created by Matt Mower on 20/07/2008.
 *  Copyright 2008 LucidMac Software. All rights reserved.
 *
 */

#import <CoreAudio/CoreAudio.h>

#import <MacRuby/MacRuby.h>
#import "String+AsRubyBlock.h"

// Type to represent compass directions (for a hex)
typedef enum tagDirection {
  N = 0,
  NE,
  SE,
  S,
  SW,
  NW
  } Direction;

#define INVERSE_DIRECTION( direction ) ((direction + 3) % 6)

#define ASSERT_VALID_DIRECTION( d ) NSAssert1( d>=0 && d<=5, @"Invalid direction %d specified", d )

// Define the size of the Harmonic Table
#define HTABLE_COLS 17
#define HTABLE_ROWS 12

// To make calculations a little easier
#define HTABLE_SIZE (HTABLE_COLS * HTABLE_ROWS)
#define HTABLE_MAX_COL (HTABLE_COLS - 1)
#define HTABLE_MAX_ROW (HTABLE_ROWS - 1)

// Calculate an offset into a linear array representing a hex-table
#define COL_ROW_OFFSET(col,row) ((col * HTABLE_ROWS) + row)

// Notification names
// extern NSString* notifyObjectSelectionDidChange;
extern NSString * const ELNotifyObjectSelectionDidChange;

extern NSString * const ELNotifyCellWasUpdated;

// Defaults keys

extern NSString * const ELDefaultCellBackgroundColor;
extern NSString * const ELDefaultCellBorderColor;
extern NSString * const ELDefaultSelectedCellBackgroundColor;
extern NSString * const ELDefaultSelectedCellBorderColor;
extern NSString * const ELDefaultToolColor;
extern NSString * const ELDefaultActivePlayheadColor;

extern NSString * const ELTonicNoteColor;
extern NSString * const ELScaleNoteColor;

#import "ELXmlData.h"

#import "ELKnob.h"
#import "ELIntegerKnob.h"
#import "ELFloatKnob.h"
#import "ELBooleanKnob.h"
