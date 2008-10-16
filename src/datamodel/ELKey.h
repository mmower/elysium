//
//  ELKey.h
//  Elysium
//
//  Created by Matt Mower on 15/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELKey : NSObject {
  NSString *name;
  NSArray *scale;
}

@property (readonly) NSString *name;
@property (readonly) NSArray *scale;

+ (NSArray *)allKeys;
+ (ELKey *)keyNamed:(NSString *)name;
+ (ELKey *)noKey;

- (id)initWithName:(NSString *)name scale:(NSArray *)scale;


@end
