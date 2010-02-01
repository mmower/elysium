//
//  ELScriptEngine.h
//  Elysium
//
//  Created by Matt Mower on 01/10/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class JSCocoa;

@class ELPlayer;


@interface ELScriptEngine : NSObject {
  JSCocoa     *_js;
}


@property JSCocoa *js;


- (id)initForPlayer:(ELPlayer *)player;

@end
