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
  ELDial  *directionDial;
  ELDial  *timeToLiveDial;
  ELDial  *pulseEveryDial;
  ELDial  *offsetDial;
}

@property ELDial *directionDial;
@property ELDial *timeToLiveDial;
@property ELDial *pulseEveryDial;
@property ELDial *offsetDial;

- (BOOL)shouldPulseOnBeat:(int)beat;

@end
