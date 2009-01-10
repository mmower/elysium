//
//  ELBlock.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

#import "ELScript.h"

@class ScriptInspectorController;

@interface RubyBlock : ELScript {
  id proc;
}

@end
