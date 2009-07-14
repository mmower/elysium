//
//  ELDialBank.m
//  Elysium
//
//  Created by Matt Mower on 07/07/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELDialBank.h"

#import "ELDial.h"

@implementation ELDialBank

+ (ELDial *)defaultTempoDial {
  return [[ELDial alloc] initWithName:@"tempo"
                              toolTip:@"Controls tempo in Beats Per Minute (BPM)"
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTempoKey]
                                  min:15
                                  max:600
                                 step:1];
}

+ (ELDial *)defaultBarLengthDial {
  return [[ELDial alloc] initWithName:@"barLength"
                              toolTip:@"Controls how many beats there are to a bar."
                                  tag:0
                               player:nil
                             assigned:4
                                  min:1
                                  max:24
                                 step:1];
}

+ (ELDial *)defaultTriggerModeDial {
  return [[ELDial alloc] initWithName:@"triggerMode"
                              toolTip:@"Controls the trigger for a generator to make new playheads."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:2
                                 step:1];
}

+ (ELDial *)defaultTimeToLiveDial {
  return [[ELDial alloc] initWithName:@"timeToLive"
                              toolTip:@"Controls how many beat a playhead lives for."
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultTTLKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultPulseEveryDial {
  return [[ELDial alloc] initWithName:@"pulseEvery"
                              toolTip:@"Controls the beat on which generators create new playheads."
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultPulseCountKey]
                                  min:1
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultVelocityDial {
  return [[ELDial alloc] initWithName:@"velocity"
                              toolTip:@"Controls the MIDI velocity for notes except the first in each bar."
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultVelocityKey]
                                  min:1
                                  max:127
                                 step:1];
}

+ (ELDial *)defaultEmphasisDial {
  return [[ELDial alloc] initWithName:@"emphasis"
                              toolTip:@"Controls the MIDI velocity of the first note in each bar."
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultEmphasisKey]
                                  min:1
                                  max:127
                                 step:1];
}

+ (ELDial *)defaultTempoSyncDial {
  assert( YES == 1);
  assert( NO == 0 );
  return [[ELDial alloc] initWithName:@"tempoSync"
                              toolTip:@"Controls whether note length is sync'd to tempo or freely assigned."
                                  tag:0
                               player:nil
                             assigned:NO
                                  min:NO
                                  max:YES
                                 step:1];
}

+ (ELDial *)defaultNoteLengthDial {
  return [[ELDial alloc] initWithName:@"noteLength"
                              toolTip:@"Controls the length of time over which a note is held."
                                  tag:0
                               player:nil
                             assigned:[[NSUserDefaults standardUserDefaults] integerForKey:ELDefaultDurationKey]
                                  min:100
                                  max:5000
                                 step:100];
}

+ (ELDial *)defaultTransposeDial {
  return [[ELDial alloc] initWithName:@"transpose"
                              toolTip:@"Controls note transposition from 2 octaves down to 2 octaves up."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:-24
                                  max:24
                                 step:1];
}

+ (ELDial *)defaultEnabledDial {
  return [[ELDial alloc] initWithName:@"enabled"
                              toolTip:@"Controls whether this object is enabled or not."
                                  tag:0
                            boolValue:YES];
}

+ (ELDial *)defaultPDial {
  return [[ELDial alloc] initWithName:@"p"
                              toolTip:@"Controls the probability that this object will be triggered."
                                  tag:0
                               player:nil
                             assigned:100
                                  min:0
                                  max:100
                                 step:1];
}

+ (ELDial *)defaultGateDial {
  return [[ELDial alloc] initWithName:@"gate"
                              toolTip:@"Controls the number of playheads that must enter to trigger this object."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:32
                                 step:1];
}

+ (ELDial *)defaultDirectionDial {
  return [[ELDial alloc] initWithName:@"direction"
                              toolTip:@"Controls which direction playheads are generated in."
                                  tag:0
                               player:nil
                             assigned:N
                                  min:0
                                  max:5
                                 step:1];
}

+ (ELDial *)defaultOffsetDial {
  return [[ELDial alloc] initWithName:@"offset"
                              toolTip:@"Controls how many beats playhead generation is offset by."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:64
                                 step:1];
}

+ (ELDial *)defaultTriadDial {
  return [[ELDial alloc] initWithName:@"triad"
                              toolTip:@"Controls whether (and which) triad will be played on this note."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:6
                                 step:1];
}

+ (ELDial *)defaultGhostsDial {
  return [[ELDial alloc] initWithName:@"ghosts"
                              toolTip:@"Controls the number of ghost notes that will play on subsequent beats."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:16
                                 step:1];
}

+ (ELDial *)defaultOverrideDial {
  return [[ELDial alloc] initWithName:@"override"
                              toolTip:@"Controls whether MIDI channel send overrides are in effect."
                                  tag:0
                            boolValue:NO];
}


+ (ELDial *)defaultChannelOverrideDial:(int)channel {
  return [[ELDial alloc] initWithName:[NSString stringWithFormat:@"chan%dOverride",channel]
                              toolTip:@"Controls the probability that this object will be triggered."
                                  tag:channel
                               player:nil
                             assigned:0
                                  min:0
                                  max:100
                                 step:1];
}


+ (ELDial *)defaultBounceBackDial {
  return [[ELDial alloc] initWithName:@"bounceBack"
                              toolTip:@"Controls whether this split token will also send a playhead back along the original direction."
                                  tag:0
                            boolValue:NO];
}

+ (ELDial *)defaultClockWiseDial {
  return [[ELDial alloc] initWithName:@"clockwise"
                              toolTip:@"Controls whether this spinner rotates clockwise or anticlockwise."
                                  tag:0
                            boolValue:YES];
}

+ (ELDial *)defaultSteppingDial {
  return [[ELDial alloc] initWithName:@"stepping"
                              toolTip:@"Controls how many compass points this spinner rotates at a time."
                                  tag:0
                               player:nil
                             assigned:1
                                  min:0
                                  max:5
                                 step:1];
}

+ (ELDial *)defaultSkipCountDial {
  return [[ELDial alloc] initWithName:@"skip"
                              toolTip:@"Controls how many extra cells a playhead skips over when it moves."
                                  tag:0
                               player:nil
                             assigned:0
                                  min:0
                                  max:8
                                 step:1];
}

@end
