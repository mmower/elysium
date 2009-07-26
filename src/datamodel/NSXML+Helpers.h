//
//  NSXML+Helpers.h
//  Elysium
//
//  Created by Matt Mower on 04/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

@class ELDial;
@class ELPlayer;

@interface NSArray (NSXML_Helpers)

- (NSXMLElement *)firstXMLElement;
- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

@end

@interface NSXMLElement (NSXML_Helpers)

- (ELDial *)loadDial:(NSString *)name parent:(ELDial *)parent player:(ELPlayer *)player error:(NSError **)error;
- (BOOL)attributeAsBool:(NSString *)name;
- (NSString *)attributeAsString:(NSString *)name;
- (int)attributeAsInteger:(NSString *)name defaultValue:(int)defval;
- (int)attributeAsInteger:(NSString *)name hasValue:(BOOL *)hasValue;
- (double)attributeAsDouble:(NSString *)name defaultValue:(double)defval;
- (double)attributeAsDouble:(NSString *)name hasValue:(BOOL *)hasValue;

@end

@interface NSError (NSXML_Helpers)

+ (NSError *)errorForLoadFailure:(NSString *)message code:(int)code withError:(NSError **)underlyingError;

@end