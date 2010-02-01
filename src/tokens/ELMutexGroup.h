//
//  ELMutexGroup.h
//  Elysium
//
//  Created by Matt Mower on 30/09/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELToken;


typedef enum {
  mgFirst,
  mgRoundRobin,
  mgRandom
} ELMutexGroupMode;


@interface ELMutexGroup : NSObject {
  ELMutexGroupMode    _mode;
  NSMutableArray      *_members;
  NSUInteger          _last;
}


- (id)initWithMode:(ELMutexGroupMode)mode;


@property (nonatomic) ELMutexGroupMode mode;
@property (readonly,nonatomic,retain) NSMutableArray *members;


- (ELToken *)selectAction;


@end
