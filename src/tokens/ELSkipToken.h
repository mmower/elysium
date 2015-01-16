//
//  ELSkipToken.h
//  Elysium
//
//  Created by Matt Mower on 23/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "ELToken.h"

@interface ELSkipToken : ELToken {
    ELDial *_skipCountDial;
}

@property (nonatomic, strong) ELDial *skipCountDial;

- (id)initWithSkipCountDial:(ELDial *)skipCountDial;

@end
