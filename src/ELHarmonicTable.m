//
//  ELHarmonicTable.m
//  Elysium
//
//  Created by Matt Mower on 19/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"
#import "ELNote.h"
#import "ELHarmonicTable.h"

@implementation ELHarmonicTable

- (id)init {
  if( ( self = [super init] ) != nil ) {
    NSArray *notes = [NSArray arrayWithObjects:
                @"A#1",@"F1",@"C2",@"G2",@"D3",@"A3",@"E4",@"B4",@"F#5",@"C#6",@"G#6",@"D#7",
                @"D1",@"A1",@"E2",@"B2",@"F#3",@"C#4",@"G#4",@"D#5",@"A#5",@"F6",@"C7",@"G7",
                @"B1",@"F#1",@"C#2",@"G#2",@"D#3",@"A#3",@"F4",@"C5",@"G5",@"D6",@"A6",@"E7",
                @"D#1",@"A#1",@"F2",@"C3",@"G3",@"D4",@"A4",@"E5",@"B5",@"F#6",@"C#7",@"G#7",
                @"C1",@"G1",@"D2",@"A2",@"E3",@"B3",@"F#4",@"C#5",@"G#5",@"D#6",@"A#6",@"F7",
                @"E1",@"B1",@"F#2",@"C#3",@"G#3",@"D#4",@"A#4",@"F5",@"C6",@"G6",@"D7",@"A7",
                @"C#1",@"G#1",@"D#2",@"A#2",@"F3",@"C4",@"G4",@"D5",@"A5",@"E6",@"B6",@"F#7",
                @"F1",@"C2",@"G2",@"D3",@"A3",@"E4",@"B4",@"F#5",@"C#6",@"G#6",@"D#7",@"A#7",
                @"D1",@"A1",@"E2",@"B2",@"F#3",@"C#4",@"G#4",@"D#5",@"A#5",@"F6",@"C7",@"G7",
                @"F#1",@"C#2",@"G#2",@"D#3",@"A#3",@"F4",@"C5",@"G5",@"D6",@"A6",@"E7",@"B7",
                @"D#1",@"A#1",@"F2",@"C3",@"G3",@"D4",@"A4",@"E5",@"B5",@"F#6",@"C#7",@"G#7",
                @"G1",@"D2",@"A2",@"E3",@"B3",@"F#4",@"C#5",@"G#5",@"D#6",@"A#6",@"F7",@"C8",
                @"E1",@"B1",@"F#2",@"C#3",@"G#3",@"D#4",@"A#4",@"F5",@"C6",@"G6",@"D7",@"A7",
                @"G#1",@"D#2",@"A#2",@"F3",@"C4",@"G4",@"D5",@"A5",@"E6",@"B6",@"F#7",@"C#8",
                @"F1",@"C2",@"G2",@"D3",@"A3",@"E4",@"B4",@"F#5",@"C#6",@"G#6",@"D#7",@"A#7",
                @"A1",@"E2",@"B2",@"F#3",@"C#4",@"G#4",@"D#5",@"A#5",@"F6",@"C7",@"G7",@"D8",
                @"F#1",@"C#2",@"G#2",@"D#3",@"A#3",@"F4",@"C5",@"G5",@"D6",@"A6",@"E7",@"B7",
                nil
                ];
    
    entries = [NSMutableArray arrayWithCapacity:(COLUMNS*ROWS)];
    
    for( int col = 0; col < COLUMNS; col++ ) {
      for( int row = 0; row < ROWS; row++ ) {
        ELNote *note = [[ELNote alloc] initWithName:[notes objectAtIndex:COL_ROW_OFFSET(col,row)]];
        [entries insertObject:note atIndex:COL_ROW_OFFSET(col,row)];
      }
    }
  }
  
  return self;
}

- (ELNote *)noteAtCol:(int)col row:(int)row {
  return [entries objectAtIndex:COL_ROW_OFFSET(col,row)];
  
}

- (int)size {
  return ROWS * COLUMNS;
}

- (int)cols {
  return COLUMNS;
}

- (int)rows {
  return ROWS;
}

@end
