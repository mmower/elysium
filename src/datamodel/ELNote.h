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

@property (nonatomic,readonly) int number;
@property (nonatomic,readonly) int octave;
@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSString *tone;
@property (nonatomic,readonly) NSString *alternateTone;
@property (nonatomic,readonly) NSString *flattenedName;

- (id)initWithName:(NSString *)name;

- (NSString *)tone:(BOOL)flat;

@end
