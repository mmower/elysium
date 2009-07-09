//
//  ELDialBank.h
//  Elysium
//
//  Created by Matt Mower on 07/07/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELDial;

@interface ELDialBank : NSObject {
}

+ (ELDial *)defaultTempoDial;
+ (ELDial *)defaultBarLengthDial;
+ (ELDial *)defaultTimeToLiveDial;
+ (ELDial *)defaultPulseEveryDial;
+ (ELDial *)defaultTriggerModeDial;
+ (ELDial *)defaultVelocityDial;
+ (ELDial *)defaultEmphasisDial;
+ (ELDial *)defaultTempoSyncDial;
+ (ELDial *)defaultNoteLengthDial;
+ (ELDial *)defaultTransposeDial;
+ (ELDial *)defaultEnabledDial;
+ (ELDial *)defaultPDial;
+ (ELDial *)defaultGateDial;
+ (ELDial *)defaultDirectionDial;
+ (ELDial *)defaultOffsetDial;
+ (ELDial *)defaultTriadDial;
+ (ELDial *)defaultGhostsDial;
+ (ELDial *)defaultOverrideDial;
+ (ELDial *)defaultBounceBackDial;
+ (ELDial *)defaultClockWiseDial;
+ (ELDial *)defaultSteppingDial;
+ (ELDial *)defaultSkipCountDial;

@end
