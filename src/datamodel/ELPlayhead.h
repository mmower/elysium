//
//  ELPlayhead.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

@class ELCell;
@class ELLayer;

@interface ELPlayhead : NSObject {
    // ELLayer   *_layer;
    ELCell *_parent;
    ELCell *_position;
    Direction _direction;
    int _skipCount;
    int _TTL;
    BOOL _isNew;
}

- (id)initWithPosition:(ELCell *)position direction:(Direction)direction TTL:(int)TTL;

@property (nonatomic, strong) ELCell *position;
@property (nonatomic, strong) ELCell *parent;
@property (nonatomic) Direction direction;
@property  (nonatomic) int skipCount;
@property  (nonatomic) int TTL;
@property  (nonatomic) BOOL isNew;
@property (nonatomic,readonly) BOOL isDead;

- (void)advance;
- (void)cleanup;
- (void)kill;


@end
