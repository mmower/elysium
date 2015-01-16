//
//  ELNoteToken.h
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELToken.h"

@interface ELNoteToken : ELToken {
    ELDial *_velocityDial;
    ELDial *_emphasisDial;
    ELDial *_tempoSyncDial;
    ELDial *_noteLengthDial;
    ELDial *_triadDial;
    ELDial *_ghostsDial;
    ELDial *_overrideDial;
    
    ELDial *_chan1OverrideDial;
    ELDial *_chan2OverrideDial;
    ELDial *_chan3OverrideDial;
    ELDial *_chan4OverrideDial;
    ELDial *_chan5OverrideDial;
    ELDial *_chan6OverrideDial;
    ELDial *_chan7OverrideDial;
    ELDial *_chan8OverrideDial;
}

- (id)initWithVelocityDial:(ELDial *)velocityDial
              emphasisDial:(ELDial *)emphasisDial
             tempoSyncDial:(ELDial *)tempoSyncDial
            noteLengthDial:(ELDial *)durationDial
                 triadDial:(ELDial *)triadDial
                ghostsDial:(ELDial *)ghostsDial
              overrideDial:(ELDial *)overrideDial
         chan1OverrideDial:(ELDial *)chan1OverrideDial
         chan2OverrideDial:(ELDial *)chan2OverrideDial
         chan3OverrideDial:(ELDial *)chan3OverrideDial
         chan4OverrideDial:(ELDial *)chan4OverrideDial
         chan5OverrideDial:(ELDial *)chan5OverrideDial
         chan6OverrideDial:(ELDial *)chan6OverrideDial
         chan7OverrideDial:(ELDial *)chan7OverrideDial
         chan8OverrideDial:(ELDial *)chan8OverrideDial;

@property (nonatomic, strong) ELDial *velocityDial;
@property (nonatomic, strong) ELDial *emphasisDial;
@property (nonatomic, strong) ELDial *tempoSyncDial;
@property (nonatomic, strong) ELDial *noteLengthDial;
@property (nonatomic, strong) ELDial *triadDial;
@property (nonatomic, strong) ELDial *ghostsDial;
@property (nonatomic, strong) ELDial *overrideDial;
@property (nonatomic, strong) ELDial *chan1OverrideDial;
@property (nonatomic, strong) ELDial *chan2OverrideDial;
@property (nonatomic, strong) ELDial *chan3OverrideDial;
@property (nonatomic, strong) ELDial *chan4OverrideDial;
@property (nonatomic, strong) ELDial *chan5OverrideDial;
@property (nonatomic, strong) ELDial *chan6OverrideDial;
@property (nonatomic, strong) ELDial *chan7OverrideDial;
@property (nonatomic, strong) ELDial *chan8OverrideDial;

@end
