//
//  NSXML+Helpers.m
//  Elysium
//
//  Created by Matt Mower on 04/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "NSXML+Helpers.h"

#import "ELDial.h"
#import "ELPlayer.h"

@implementation NSArray (NSXML_Helpers)

- (NSXMLElement *)firstXMLElement {
  if( [self count] < 1 ) {
    return nil;
  }
  
  return (NSXMLElement *)[self objectAtIndex:0];
}


- (BOOL)isEmpty {
  return [self count] == 0;
}


- (BOOL)isNotEmpty {
  return [self count] > 0;
}


@end

@implementation NSXMLElement (NSXML_Helpers)

- (ELDial *)loadDial:(NSString *)name parent:(ELDial *)parent player:(ELPlayer *)player error:(NSError **)error {
  return [[ELDial alloc] initWithXmlRepresentation:[[self nodesForXPath:[NSString stringWithFormat:@"controls/dial[@name='%@']",name] error:error] firstXMLElement]
                                            parent:parent
                                            player:player
                                             error:error];
}


- (BOOL)attributeAsBool:(NSString *)name {
  return [[self attributeAsString:name] boolValue];
}


- (NSString *)attributeAsString:(NSString *)name {
  NSXMLNode *attributeNode = [self attributeForName:name];
  if( attributeNode ) {
    return [attributeNode stringValue];
  } else {
    return nil;
  }
}

- (int)attributeAsInteger:(NSString *)name defaultValue:(int)defval {
  NSString *attribute = [self attributeAsString:name];
  if( attribute ) {
    return [attribute intValue];
  } else {
    return defval;
  }
}


- (int)attributeAsInteger:(NSString *)name hasValue:(BOOL *)hasValue {
  NSString *attribute = [self attributeAsString:name];
  if( attribute ) {
    *hasValue = YES;
    return [attribute intValue];
  } else {
    *hasValue = NO;
    return INT_MAX;
  }
}


- (double)attributeAsDouble:(NSString *)name defaultValue:(double)defval {
  NSString *attribute = [self attributeAsString:name];
  if( attribute ) {
    return [attribute doubleValue];
  } else {
    return defval;
  }
}


- (double)attributeAsDouble:(NSString *)name hasValue:(BOOL *)hasValue {
  NSString *attribute = [self attributeAsString:name];
  if( attribute ) {
    *hasValue = YES;
    return [attribute doubleValue];
  } else {
    *hasValue = NO;
    return 0.0;
  }
}


@end

@implementation NSError (NSXML_Helpers)

+ (NSError *)errorForLoadFailure:(NSString *)message code:(int)code withError:(NSError **)underlyingError {
  NSDictionary* userInfo;
  
  if( underlyingError && *underlyingError ) {
    userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      message,NSLocalizedDescriptionKey,
                                      *underlyingError,NSUnderlyingErrorKey,
                                      nil];
  } else {
    userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      message,NSLocalizedDescriptionKey,
                                      nil];
  }
  
  return [[NSError alloc] initWithDomain:ELErrorDomain code:code userInfo:userInfo];
}

@end
