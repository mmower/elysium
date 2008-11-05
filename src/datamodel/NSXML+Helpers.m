//
//  NSXML+Helpers.m
//  Elysium
//
//  Created by Matt Mower on 04/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "NSXML+Helpers.h"

@implementation NSArray (NSXML_Helpers)

- (NSXMLElement *)firstXMLElement {
  if( [self count] < 1 ) {
    return nil;
  }
  
  return (NSXMLElement *)[self objectAtIndex:0];
}

@end

@implementation NSXMLElement (NSXML_Helpers)

- (NSString *)attributeAsString:(NSString *)_name_ {
  NSXMLNode *attributeNode = [self attributeForName:_name_];
  if( attributeNode ) {
    return [attributeNode stringValue];
  } else {
    return nil;
  }
}

@end

@implementation NSError (NSXML_Helpers)

+ (NSError *)errorForLoadFailure:(NSString *)_message_ code:(int)_code_ withError:(NSError **)_underlyingError_ {
  NSDictionary* userInfo;
  
  if( *_underlyingError_ ) {
    userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      _message_,NSLocalizedDescriptionKey,
                                      *_underlyingError_,NSUnderlyingErrorKey,
                                      nil];
  } else {
    userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                      _message_,NSLocalizedDescriptionKey,
                                      nil];
  }
  
  return [[NSError alloc] initWithDomain:ELErrorDomain code:_code_ userInfo:userInfo];
}

@end
