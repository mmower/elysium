//
//  String+AsJavascriptFunction.h
//  Elysium
//
//  Created by Matt Mower on 10/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "JavascriptCallback.h"

@interface NSString (String_AsJavascriptFunction)

- (JavascriptCallback *)asJavascriptFunction;

@end
