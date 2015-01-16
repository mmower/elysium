//
//  ELScriptPackage.h
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELTimerCallback.h"

@interface ELScriptPackage : NSObject <ELXmlData> {
    ELPlayer *_player;
    
    BOOL _flag[8];
    
    float _var[8];
    float _varMin[8];
    float _varMax[8];
    
    ELTimerCallback *_timer[4];
}

@property (nonatomic, assign)  ELPlayer *player;

@property (nonatomic) BOOL f1;
@property (nonatomic) BOOL f2;
@property (nonatomic) BOOL f3;
@property (nonatomic) BOOL f4;
@property (nonatomic) BOOL f5;
@property (nonatomic) BOOL f6;
@property (nonatomic) BOOL f7;
@property (nonatomic) BOOL f8;

@property (nonatomic) float v1;
@property (nonatomic) float v1min;
@property (nonatomic) float v1max;

@property (nonatomic) float v2;
@property (nonatomic) float v2min;
@property (nonatomic) float v2max;

@property (nonatomic) float v3;
@property (nonatomic) float v3min;
@property (nonatomic) float v3max;

@property (nonatomic) float v4;
@property (nonatomic) float v4min;
@property (nonatomic) float v4max;

@property (nonatomic) float v5;
@property (nonatomic) float v5min;
@property (nonatomic) float v5max;

@property (nonatomic) float v6;
@property (nonatomic) float v6min;
@property (nonatomic) float v6max;

@property (nonatomic) float v7;
@property (nonatomic) float v7min;
@property (nonatomic) float v7max;

@property (nonatomic) float v8;
@property (nonatomic) float v8min;
@property (nonatomic) float v8max;

@property (nonatomic, readonly,strong) ELTimerCallback *timer1;
@property (nonatomic, readonly,strong) ELTimerCallback *timer2;
@property (nonatomic, readonly,strong) ELTimerCallback *timer3;
@property (nonatomic, readonly,strong) ELTimerCallback *timer4;
- (id)initWithPlayer:(ELPlayer *)player;
@end
