//
//  ELNote.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright LucidMac Software 2008 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELNote : NSObject
{
  int       number;
  int       octave;
  NSString  *name;
  NSString  *tone;
  NSString  *alternateTone;
}

+ (int)noteNumber:(NSString *)noteName;
+ (NSString *)noteName:(int)noteNum;

- (id)initWithName:(NSString *)name;

- (int)number;
- (int)octave;

- (NSString *)name;
- (NSString *)tone;
- (NSString *)alternateTone;
- (NSString *)tone:(BOOL)flat;
- (NSString *)flattenedName;

@end
