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

- (id)initWithParent:(ELConfig *)_parent_ {
  if( self = [super init] ) {
    data     = [[NSMutableDictionary alloc] init];
    snapshot = nil;
    children = [[NSMutableArray alloc] init];
    
    [self setParent:_parent_];
  }
  
  return self;
}

- (void)addChild:(ELConfig *)_child_ {
  [children addObject:_child_];
}

- (void)removeChild:(ELConfig *)_child_ {
  [children removeObject:_child_];
}

@dynamic parent;

- (ELConfig *)parent {
  return parent;
}

- (void)setParent:(ELConfig *)_parent_ {
  if( parent ) {
    [parent removeChild:self];
  }
  
  parent = _parent_;
  [parent addChild:self];
}

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

- (void)setBoolean:(BOOL)_value_ forKey:(NSString *)_key_ {
  [self setValue:[NSNumber numberWithBool:_value_] forKey:_key_];
}

- (BOOL)booleanForKey:(NSString *)_key_ {
  return [[self valueForKey:_key_] boolValue];
}

// Make a snapshot of this configuration and all sub-configurations
- (void)snapshot {
  snapshot = [data mutableCopy];
  [children makeObjectsPerformSelector:@selector(snapshot)];
}

// Restore the last snapshot of this configuration and all sub-configurations
- (void)restore {
  if( snapshot ) {
    data = snapshot;
    snapshot = nil;
  }
  [children makeObjectsPerformSelector:@selector(restore)];
}

// Debug support

- (void)dump {
  for( NSString *key in [data allKeys] ) {
    NSLog( @"config %@ => %@", key, [data objectForKey:key] );
  }
}

// Implement ELData protocol

- (NSXMLElement *)asXMLData {
  NSXMLElement *configElement = [NSXMLNode elementWithName:@"config"];
  
  for( NSString *key in [data allKeys] ) {
    NSXMLElement *dataElement = [NSXMLNode elementWithName:@"data"];
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[self valueForKey:key] forKey:key];
    [dataElement setAttributesAsDictionary:attributes];
    [configElement addChild:dataElement];
  }
  
  return configElement;
}

- (BOOL)fromXMLData:(NSXMLElement *)data {
  return NO;
}

@end
