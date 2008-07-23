/*
 *  Elysium.h
 *  Elysium
 *
 *  Created by Matt Mower on 20/07/2008.
 *  Copyright 2008 LucidMac Software. All rights reserved.
 *
 */

#import <CoreAudio/CoreAudio.h>

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

// Define the size of the Harmonic Table
#define HTABLE_COLS 17
#define HTABLE_ROWS 12

// To make calculations a little easier
#define HTABLE_SIZE (HTABLE_COLS * HTABLE_ROWS)
#define HTABLE_MAX_COL (HTABLE_COLS - 1)
#define HTABLE_MAX_ROW (HTABLE_ROWS - 1)

// Calculate an offset into a linear array representing a hex-table
#define COL_ROW_OFFSET(col,row) ((col * HTABLE_ROWS) + row)

// MIDI message constants
#define MIDI_ON   0x90
#define MIDI_OFF  0x80
#define MIDI_PC   0xC0
