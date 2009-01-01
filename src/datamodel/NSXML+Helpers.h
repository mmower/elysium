//
//  NSXML+Helpers.h
//  Elysium
//
//  Created by Matt Mower on 04/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@interface NSArray (NSXML_Helpers)

- (NSXMLElement *)firstXMLElement;

@end

@interface NSXMLElement (NSXML_Helpers)

- (NSString *)attributeAsString:(NSString *)name;

@end

@interface NSError (NSXML_Helpers)

+ (NSError *)errorForLoadFailure:(NSString *)message code:(int)code withError:(NSError **)underlyingError;

@end