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
  NSDictionary  *_channelSends;
}

- (id)initWithVelocityDial:(ELDial *)velocityDial
              emphasisDial:(ELDial *)emphasisDial
             tempoSyncDial:(ELDial *)tempoSyncDial
            noteLengthDial:(ELDial *)durationDial
                 triadDial:(ELDial *)triadDial
                ghostsDial:(ELDial *)ghostsDial
              overrideDial:(ELDial *)overrideDial
              channelSends:(NSDictionary *)channelSends;

@property ELDial *velocityDial;
@property ELDial *emphasisDial;
@property ELDial *tempoSyncDial;
@property ELDial *noteLengthDial;
@property ELDial *triadDial;
@property ELDial *ghostsDial;
@property ELDial *overrideDial;
@property (assign) NSDictionary *channelSends;

@end
