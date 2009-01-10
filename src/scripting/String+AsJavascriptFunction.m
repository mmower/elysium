//
//  String+AsJavascriptFunction.m
//  Elysium
//
//  Created by Matt Mower on 10/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "String+AsJavascriptFunction.h"

@implementation NSString (String_AsJavascriptFunction)

- (JavascriptCallback *)asJavascriptFunction {
  return [[JavascriptCallback alloc] initWithSource:self];
}

@end
