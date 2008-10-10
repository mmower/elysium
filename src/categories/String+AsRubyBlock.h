//
//  String+AsRubyBlock.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RubyBlock;

@interface NSString (String_AsRubyBlock)

- (RubyBlock *)asRubyBlock;

@end
