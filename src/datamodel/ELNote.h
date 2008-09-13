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
  NSString  *name;
}

+ (int)noteNumber:(NSString *)noteName;
+ (NSString *)noteName:(int)noteNum;

- (id)initWithNumber:(int)number;
- (id)initWithName:(NSString *)name;

- (int)number;
- (NSString *)name;

- (int)octave;

@end
