//
//  ELSegmentedControl.m
//  Elysium
//
//  Created by Matt Mower on 10/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELSegmentedControl.h"

@implementation ELSegmentedControl

+ (void)initialize {
  [self exposeBinding:@"segment0enabled"];
  [self exposeBinding:@"segment0selected"];
  [self exposeBinding:@"segment1enabled"];
  [self exposeBinding:@"segment1selected"];
  [self exposeBinding:@"segment2enabled"];
  [self exposeBinding:@"segment2selected"];
  [self exposeBinding:@"segment3enabled"];
  [self exposeBinding:@"segment3selected"];
  [self exposeBinding:@"segment4enabled"];
  [self exposeBinding:@"segment4selected"];
  [self exposeBinding:@"segment5enabled"];
  [self exposeBinding:@"segment5selected"];
  [self exposeBinding:@"segment6enabled"];
  [self exposeBinding:@"segment6selected"];
  [self exposeBinding:@"segment7enabled"];
  [self exposeBinding:@"segment7selected"];
  [self exposeBinding:@"segment8enabled"];
  [self exposeBinding:@"segment8selected"];
  [self exposeBinding:@"segment9enabled"];
  [self exposeBinding:@"segment9selected"];
  [self exposeBinding:@"segment10enabled"];
  [self exposeBinding:@"segment10selected"];
  [self exposeBinding:@"segment11enabled"];
  [self exposeBinding:@"segment11selected"];
  [self exposeBinding:@"segment12enabled"];
  [self exposeBinding:@"segment12selected"];
  [self exposeBinding:@"segment13enabled"];
  [self exposeBinding:@"segment13selected"];
  [self exposeBinding:@"segment14enabled"];
  [self exposeBinding:@"segment14selected"];
  [self exposeBinding:@"segment15enabled"];
  [self exposeBinding:@"segment15selected"];
}

@dynamic segment0enabled;

- (BOOL)segment0enabled {
  return segment1enabled;
}

- (void)setSegment0enabled:(BOOL)enabled {
  segment0enabled = enabled;
  [self setEnabled:segment0enabled forSegment:0];
}

@dynamic segment0selected;

- (BOOL)segment0selected {
  return segment1selected;
}

- (void)setSegment0selected:(BOOL)selected {
  segment0selected = selected;
  [self setSelected:segment0selected forSegment:0];
}

@dynamic segment1enabled;

- (BOOL)segment1enabled {
  return segment1enabled;
}

- (void)setSegment1enabled:(BOOL)enabled {
  segment1enabled = enabled;
  [self setEnabled:segment1enabled forSegment:1];
}

@dynamic segment1selected;

- (BOOL)segment1selected {
  return segment1selected;
}

- (void)setSegment1selected:(BOOL)selected {
  segment1selected = selected;
  [self setSelected:segment1selected forSegment:1];
}

@dynamic segment2enabled;

- (BOOL)segment2enabled {
  return segment2enabled;
}

- (void)setSegment2enabled:(BOOL)enabled {
  segment2enabled = enabled;
  [self setEnabled:segment2enabled forSegment:2];
}

@dynamic segment2selected;

- (BOOL)segment2selected {
  return segment2selected;
}

- (void)setSegment2selected:(BOOL)selected {
  segment2selected = selected;
  [self setSelected:segment2selected forSegment:2];
}

@dynamic segment3enabled;

- (BOOL)segment3enabled {
  return segment3enabled;
}

- (void)setSegment3enabled:(BOOL)enabled {
  segment3enabled = enabled;
  [self setEnabled:segment3enabled forSegment:3];
}

@dynamic segment3selected;

- (BOOL)segment3selected {
  return segment3selected;
}

- (void)setSegment3selected:(BOOL)selected {
  segment3selected = selected;
  [self setSelected:segment3selected forSegment:3];
}

@dynamic segment4enabled;

- (BOOL)segment4enabled {
  return segment4enabled;
}

- (void)setSegment4enabled:(BOOL)enabled {
  segment4enabled = enabled;
  [self setEnabled:segment4enabled forSegment:4];
}

@dynamic segment4selected;

- (BOOL)segment4selected {
  return segment4selected;
}

- (void)setSegment4selected:(BOOL)selected {
  segment4selected = selected;
  [self setSelected:segment4selected forSegment:4];
}

@dynamic segment5enabled;

- (BOOL)segment5enabled {
  return segment5enabled;
}

- (void)setSegment5enabled:(BOOL)enabled {
  segment5enabled = enabled;
  [self setEnabled:segment5enabled forSegment:5];
}

@dynamic segment5selected;

- (BOOL)segment5selected {
  return segment5selected;
}

- (void)setSegment5selected:(BOOL)selected {
  segment5selected = selected;
  [self setSelected:segment5selected forSegment:5];
}

@dynamic segment6enabled;

- (BOOL)segment6enabled {
  return segment6enabled;
}

- (void)setSegment6enabled:(BOOL)enabled {
  segment6enabled = enabled;
  [self setEnabled:segment6enabled forSegment:6];
}

@dynamic segment6selected;

- (BOOL)segment6selected {
  return segment6selected;
}

- (void)setSegment6selected:(BOOL)selected {
  segment6selected = selected;
  [self setSelected:segment6selected forSegment:6];
}

@dynamic segment7enabled;

- (BOOL)segment7enabled {
  return segment7enabled;
}

- (void)setSegment7enabled:(BOOL)enabled {
  segment7enabled = enabled;
  [self setEnabled:segment7enabled forSegment:7];
}

@dynamic segment7selected;

- (BOOL)segment7selected {
  return segment7selected;
}

- (void)setSegment7selected:(BOOL)selected {
  segment7selected = selected;
  [self setSelected:segment7selected forSegment:7];
}

@dynamic segment8enabled;

- (BOOL)segment8enabled {
  return segment8enabled;
}

- (void)setSegment8enabled:(BOOL)enabled {
  segment8enabled = enabled;
  [self setEnabled:segment8enabled forSegment:8];
}

@dynamic segment8selected;

- (BOOL)segment8selected {
  return segment8selected;
}

- (void)setSegment8selected:(BOOL)selected {
  segment8selected = selected;
  [self setSelected:segment8selected forSegment:8];
}

@dynamic segment9enabled;

- (BOOL)segment9enabled {
  return segment9enabled;
}

- (void)setSegment9enabled:(BOOL)enabled {
  segment9enabled = enabled;
  [self setEnabled:segment9enabled forSegment:9];
}

@dynamic segment9selected;

- (BOOL)segment9selected {
  return segment9selected;
}

- (void)setSegment9selected:(BOOL)selected {
  segment9selected = selected;
  [self setSelected:segment9selected forSegment:9];
}

@dynamic segment10enabled;

- (BOOL)segment10enabled {
  return segment10enabled;
}

- (void)setSegment10enabled:(BOOL)enabled {
  segment10enabled = enabled;
  [self setEnabled:segment10enabled forSegment:10];
}

@dynamic segment10selected;

- (BOOL)segment10selected {
  return segment10selected;
}

- (void)setSegment10selected:(BOOL)selected {
  segment10selected = selected;
  [self setSelected:segment10selected forSegment:10];
}

@dynamic segment11enabled;

- (BOOL)segment11enabled {
  return segment11enabled;
}

- (void)setSegment11enabled:(BOOL)enabled {
  segment11enabled = enabled;
  [self setEnabled:segment11enabled forSegment:11];
}

@dynamic segment11selected;

- (BOOL)segment11selected {
  return segment11selected;
}

- (void)setSegment11selected:(BOOL)selected {
  segment11selected = selected;
  [self setSelected:segment11selected forSegment:11];
}

@dynamic segment12enabled;

- (BOOL)segment12enabled {
  return segment12enabled;
}

- (void)setSegment12enabled:(BOOL)enabled {
  segment12enabled = enabled;
  [self setEnabled:segment12enabled forSegment:12];
}

@dynamic segment12selected;

- (BOOL)segment12selected {
  return segment12selected;
}

- (void)setSegment12selected:(BOOL)selected {
  segment12selected = selected;
  [self setSelected:segment12selected forSegment:12];
}

@dynamic segment13enabled;

- (BOOL)segment13enabled {
  return segment13enabled;
}

- (void)setSegment13enabled:(BOOL)enabled {
  segment13enabled = enabled;
  [self setEnabled:segment13enabled forSegment:13];
}

@dynamic segment13selected;

- (BOOL)segment13selected {
  return segment13selected;
}

- (void)setSegment13selected:(BOOL)selected {
  segment13selected = selected;
  [self setSelected:segment13selected forSegment:13];
}

@dynamic segment14enabled;

- (BOOL)segment14enabled {
  return segment14enabled;
}

- (void)setSegment14enabled:(BOOL)enabled {
  segment14enabled = enabled;
  [self setEnabled:segment14enabled forSegment:14];
}

@dynamic segment14selected;

- (BOOL)segment14selected {
  return segment14selected;
}

- (void)setSegment14selected:(BOOL)selected {
  segment14selected = selected;
  [self setSelected:segment14selected forSegment:14];
}

@dynamic segment15enabled;

- (BOOL)segment15enabled {
  return segment15enabled;
}

- (void)setSegment15enabled:(BOOL)enabled {
  segment15enabled = enabled;
  [self setEnabled:segment15enabled forSegment:15];
}

@dynamic segment15selected;

- (BOOL)segment15selected {
  return segment15selected;
}

- (void)setSegment15selected:(BOOL)selected {
  segment15selected = selected;
  [self setSelected:segment15selected forSegment:15];
}

@end
