//
//  ELKey.h
//  Elysium
//
//  Created by Matt Mower on 15/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELNote;

@interface ELKey : NSObject {
  NSString  *_name;
  NSArray   *_scale;
  BOOL      _flat;
}

@property (nonatomic,readonly) NSString *name;
@property (nonatomic,readonly) NSArray *scale;
@property (nonatomic,readonly) BOOL flat;

+ (NSArray *)allKeys;
+ (ELKey *)keyNamed:(NSString *)name;
+ (ELKey *)noKey;

- (NSArray *)allKeys;

- (id)initWithName:(NSString *)name scale:(NSArray *)scale;

- (BOOL)containsNote:(ELNote *)note isTonic:(BOOL *)isTonic;

@end
