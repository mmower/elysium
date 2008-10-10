//
//  ELBlock.h
//  Elysium
//
//  Created by Matt Mower on 07/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

@interface ELBlock : NSObject {
  NSString *source;
  id proc;
}

- (NSString *)source;
- (void)setSource:(NSString *)source;

- (id)eval;
- (id)evalWithArg:(id)arg;
- (id)evalWithArg:(id)arg1 arg:(id)arg2;

- (void)inspect;

@end
