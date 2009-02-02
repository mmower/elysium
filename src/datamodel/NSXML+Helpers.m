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

@end

@implementation NSXMLElement (NSXML_Helpers)

- (ELDial *)loadDial:(NSString *)name parent:(ELDial *)parent player:(ELPlayer *)player error:(NSError **)error {
  return [[ELDial alloc] initWithXmlRepresentation:[[self nodesForXPath:[NSString stringWithFormat:@"controls/dial[@name='%@']",name] error:error] firstXMLElement]
                                            parent:parent
                                            player:player
                                             error:error];
}

- (NSString *)attributeAsString:(NSString *)_name_ {
  NSXMLNode *attributeNode = [self attributeForName:_name_];
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
