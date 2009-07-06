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

- (id)initEnabled:(BOOL)enabled minimum:(int)min maximum:(int)max rest:(int)rest attack:(int)attack sustain:(int)aSustain decay:(int)aDecay {
  if( ( self = [super initEnabled:enabled minimum:min maximum:max] ) ) {
    [self setAttack:attack];
    [self setDecay:aDecay];
    [self setRest:rest];
    [self setSustain:aSustain];
  }
  
  return self;
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
    // NSXMLNode *attributeNode;
    
    [self setRest:[representation attributeAsInteger:@"rest" defaultValue:INT_MIN]];
    // 
    // attributeNode = [representation attributeForName:@"rest"];
    // if( !attributeNode ) {
    //   NSLog( @"No or invalid 'rest' attribute node for oscillator!" );
    //   return nil;
    // } else {
    //   [self setRest:[[attributeNode stringValue] intValue]];
    // }
    
    [self setAttack:[representation attributeAsInteger:@"attack" defaultValue:INT_MIN]];
    // attributeNode = [representation attributeForName:@"attack"];
    // if( !attributeNode ) {
    //   NSLog( @"No or invalid 'attack' attribute node for oscillator" );
    //   return nil;
    // } else {
    //   [self setAttack:[[attributeNode stringValue] intValue]];
    // }
    
    [self setSustain:[representation attributeAsInteger:@"sustain" defaultValue:INT_MIN]];
    // attributeNode = [representation attributeForName:@"sustain"];
    // if( !attributeNode ) {
    //   NSLog( @"No or invalid 'sustain' attribute node for oscillator" );
    //   return nil;
    // } else {
    //   [self setAttack:[[attributeNode stringValue] intValue]];
    // }
    
    [self setDecay:[representation attributeAsInteger:@"decay" defaultValue:INT_MIN]];
    // attributeNode = [representation attributeForName:@"decay"];
    // if( !attributeNode ) {
    //   NSLog( @"No or invalid 'decay' attribute node for oscillator" );
    //   return nil;
    // } else {
    //   [self setDecay:[[attributeNode stringValue] intValue]];
    // }
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
                                                maximum:[self maximum]
                                                   rest:[self rest]
                                                 attack:[self attack]
                                                sustain:[self sustain]
                                                  decay:[self decay]];
}

@end
