//
//  ELConfig.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELConfig.h"

@implementation NSString (StringValue)
- (NSString *)stringValue {
  return self;
}
@end

@implementation ELConfig

- (id)init {
  return [self initWithParent:nil];
}

- (id)initWithParent:(ELConfig *)_parent {
  if( self = [super init] ) {
    parent = _parent;
    data   = [[NSMutableDictionary alloc] init];
  }
  
  return self;
}

@synthesize parent;

- (void)removeValueForKey:(NSString *)_key {
  [data removeObjectForKey:_key];
}

- (BOOL)definesValueForKey:(NSString *)_key {
  return [data objectForKey:_key] != nil;
}

- (BOOL)inheritsValueForKey:(NSString *)_key {
  return [self hasValueForKey:_key] && ![self definesValueForKey:_key];
}

- (BOOL)hasValueForKey:(NSString *)_key {
  return [self valueForKey:_key] != nil;
}

- (id)valueForKey:(NSString *)_key {
  id value = [data objectForKey:_key];

  if( value != nil ) {
    return value;
  }
  
  if( parent == nil ) {
    return nil;
  }
  
  return [parent valueForKey:_key];
}

- (void)setValue:(id)_value forKey:(NSString *)_key {
  [data setObject:_value forKey:_key];
}

- (int)integerForKey:(NSString *)_key {
  return [[self valueForKey:_key] integerValue];
}

- (void)setInteger:(int)_value forKey:(NSString *)_key {
  [self setValue:[NSNumber numberWithInt:_value] forKey:_key];
}

- (float)floatForKey:(NSString *)_key {
  return [[self valueForKey:_key] floatValue];
}

- (void)setFloat:(float)_value forKey:(NSString *)_key {
  [self setValue:[NSNumber numberWithFloat:_value] forKey:_key];
}

- (NSString *)stringForKey:(NSString *)_key {
  return [[self valueForKey:_key] stringValue];
}

- (void)dump {
  for( NSString *key in [data allKeys] ) {
    NSLog( @"config %@ => %@", key, [data objectForKey:key] );
  }
}

@end
