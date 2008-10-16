//
//  ELKey.h
//  Elysium
//
//  Created by Matt Mower on 15/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELNote;

@interface ELKey : NSObject {
  NSString *name;
  NSArray *scale;
  BOOL    flat;
}

@property (readonly) NSString *name;
@property (readonly) NSArray *scale;
@property (readonly) BOOL flat;

+ (NSArray *)allKeys;
+ (ELKey *)keyNamed:(NSString *)name;
+ (ELKey *)noKey;

- (id)initWithName:(NSString *)name scale:(NSArray *)scale;

- (BOOL)containsNote:(ELNote *)note isTonic:(BOOL *)isTonic;

@end
