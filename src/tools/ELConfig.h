//
//  ELConfig.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELData.h"

@interface NSString ( StringValue )
- (NSString *)stringValue;
@end

@interface ELConfig : NSObject <ELData> {
  ELConfig              *parent;
  NSMutableDictionary   *data;
}

- (id)init;
- (id)initWithParent:(ELConfig *)parent;

@property ELConfig *parent;

- (void)removeValueForKey:(NSString *)key;
- (BOOL)hasValueForKey:(NSString *)key;
- (BOOL)definesValueForKey:(NSString *)key;
- (BOOL)inheritsValueForKey:(NSString *)key;

- (id)valueForKey:(NSString *)key;
- (void)setValue:(id)value forKey:(NSString *)key;

- (int)integerForKey:(NSString *)key;
- (void)setInteger:(int)value forKey:(NSString *)key;

- (float)floatForKey:(NSString *)key;
- (void)setFloat:(float)value forKey:(NSString *)key;

- (NSString *)stringForKey:(NSString *)key;

@end
