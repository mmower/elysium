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
  ELDial        *_velocityDial;
  ELDial        *_emphasisDial;
  ELDial        *_tempoSyncDial;
  ELDial        *_noteLengthDial;
  ELDial        *_triadDial;
  ELDial        *_ghostsDial;
  ELDial        *_overrideDial;
  
  ELDial        *_chan1OverrideDial;
  ELDial        *_chan2OverrideDial;
  ELDial        *_chan3OverrideDial;
  ELDial        *_chan4OverrideDial;
  ELDial        *_chan5OverrideDial;
  ELDial        *_chan6OverrideDial;
  ELDial        *_chan7OverrideDial;
  ELDial        *_chan8OverrideDial;
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

@property ELDial *velocityDial;
@property ELDial *emphasisDial;
@property ELDial *tempoSyncDial;
@property ELDial *noteLengthDial;
@property ELDial *triadDial;
@property ELDial *ghostsDial;
@property ELDial *overrideDial;
@property ELDial *chan1OverrideDial;
@property ELDial *chan2OverrideDial;
@property ELDial *chan3OverrideDial;
@property ELDial *chan4OverrideDial;
@property ELDial *chan5OverrideDial;
@property ELDial *chan6OverrideDial;
@property ELDial *chan7OverrideDial;
@property ELDial *chan8OverrideDial;

@end
