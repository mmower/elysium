//
//  ELGenerateToken.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "Elysium.h"

#import "ELToken.h"

@interface ELGenerateToken : ELToken <DirectedToken> {
    int _nextTriggerBeat;
    
    ELDial *_triggerModeDial;
    ELDial *_directionDial;
    ELDial *_timeToLiveDial;
    ELDial *_pulseEveryDial;
    ELDial *_offsetDial;
}

- (id)initWithTriggerModeDial:(ELDial *)triggerModeDial
                directionDial:(ELDial *)directionDial
               timeToLiveDial:(ELDial *)timeToLiveDial
               pulseEveryDial:(ELDial *)pulseEveryDial
                   offsetDial:(ELDial *)offsetDial;

@property (nonatomic, strong) ELDial *triggerModeDial;
@property (nonatomic, strong) ELDial *directionDial;
@property (nonatomic, strong) ELDial *timeToLiveDial;
@property (nonatomic, strong) ELDial *pulseEveryDial;
@property (nonatomic, strong) ELDial *offsetDial;

- (BOOL)shouldPulseOnBeat:(int)beat;

@end
