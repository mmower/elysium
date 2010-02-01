//
//  ELSawOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSawOscillator.h"

#import "ELOscillator.h"

@implementation ELSawOscillator

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay {
  if( ( self = [super initEnabled:enabled minimum:minimum hardMinimum:hardMinimum maximum:maximum hardMaximum:hardMaximum] ) ) {
    [self setAttack:attack];
    [self setDecay:decay];
    [self setRest:rest];
    [self setSustain:sustain];
  }
  
  return self;
}


- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)rest attack:(int)attack sustain:(int)sustain decay:(int)decay {
  return [self initEnabled:enabled minimum:minimum hardMinimum:minimum maximum:maximum hardMaximum:maximum rest:rest attack:attack sustain:sustain decay:decay];
}

- (NSString *)type {
  return @"Saw";
}

@synthesize rest = _rest;

- (void)setRest:(int)newRest {
  _rest = newRest;
  [self updateBasesAndDeltas];
}

@synthesize attack = _attack;

- (void)setAttack:(int)newAttack {
  _attack = newAttack;
  [self updateBasesAndDeltas];
}

@synthesize sustain = _sustain;

- (void)setSustain:(int)newSustain {
  _sustain = newSustain;
  [self updateBasesAndDeltas];
}

@synthesize decay = _decay;

- (void)setDecay:(int)newDecay {
  _decay = newDecay;
  [self updateBasesAndDeltas];
}


#pragma mark Object behaviours

- (void)updateBasesAndDeltas {
  _period = [self rest] + [self attack] + [self sustain] + [self decay];
  
  if( [self attack] > 0 ) {
    _attackDelta = ( [self maximum] - [self minimum] ) / (float)[self attack];
  }
  
  if( [self decay] > 0 ) {
    _decayDelta = ( [self maximum] - [self minimum] ) / (float)[self decay];
  }
}


- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % _period;
    return [self generateWithT:t];
}


- (int)generateWithT:(int)t {
  if( t <= [self attack] ) {
    return ( _attackDelta * t ) + [self minimum];
  } else if( t <= ( [self attack] + [self sustain] ) ) {
    return [self maximum];
  } else if( t <= ( [self attack] + [self sustain] + [self decay] ) ) {
    return [self maximum] - ( _decayDelta * ( t - ( [self attack] + [self sustain] ) ) );
  } else {
    return [self minimum];
  }
}


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    [self setRest:[representation attributeAsInteger:@"rest" defaultValue:INT_MIN]];
    [self setAttack:[representation attributeAsInteger:@"attack" defaultValue:INT_MIN]];
    [self setSustain:[representation attributeAsInteger:@"sustain" defaultValue:INT_MIN]];
    [self setDecay:[representation attributeAsInteger:@"decay" defaultValue:INT_MIN]];
  }
  
  return self;
}


- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
  
  [attributes setObject:[NSNumber numberWithInteger:[self rest]] forKey:@"rest"];
  [attributes setObject:[NSNumber numberWithInteger:[self attack]] forKey:@"attack"];
  [attributes setObject:[NSNumber numberWithInteger:[self sustain]] forKey:@"sustain"];
  [attributes setObject:[NSNumber numberWithInteger:[self decay]] forKey:@"decay"];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                minimum:[self minimum]
                                            hardMinimum:[self hardMinimum]
                                                maximum:[self maximum]
                                            hardMaximum:[self hardMaximum]
                                                   rest:[self rest]
                                                 attack:[self attack]
                                                sustain:[self sustain]
                                                  decay:[self decay]];
}

@end
