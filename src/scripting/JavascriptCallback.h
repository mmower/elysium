//
//  JavascriptCallback.h
//  Elysium
//
//  Created by Matt Mower on 09/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <JSCocoa/JSCocoa.h>

#import "ELScript.h"

@interface JavascriptCallback : ELScript {
  JSContextRef              ctx;
  JSObjectRef               function;
}

- (id)evalWithArgs:(NSArray *)args;

@end
