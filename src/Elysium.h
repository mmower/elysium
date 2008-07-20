/*
 *  Elysium.h
 *  Elysium
 *
 *  Created by Matt Mower on 20/07/2008.
 *  Copyright 2008 LucidMac Software. All rights reserved.
 *
 */

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
#define MAX_HTABLE_COL (HTABLE_COLS - 1)
#define MAX_HTABLE_ROW (HTABLE_ROWS - 1)

// Calculate an offset into a linear array representing a hex-table
#define COL_ROW_OFFSET(col,row) ((col * HTABLE_ROWS) + row)
