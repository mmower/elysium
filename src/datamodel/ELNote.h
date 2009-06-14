//
//  ELNote.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELPlayable.h"

@interface ELNote : ELPlayable
{
  int       _number;
  int       _octave;
  NSString  *_name;
  NSString  *_tone;
  NSString  *_alternateTone;
}

+ (int)noteNumber:(NSString *)noteName;
+ (NSString *)noteName:(int)noteNum;

@property (readonly) int number;
@property (readonly) int octave;
@property (readonly) NSString *name;
@property (readonly) NSString *tone;
@property (readonly) NSString *alternateTone;
@property (readonly) NSString *flattenedName;

- (id)initWithName:(NSString *)name;

- (NSString *)tone:(BOOL)flat;

@end
