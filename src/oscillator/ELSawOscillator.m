//
//  ELSawOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELSawOscillator.h"

#import "ELOscillator.h"

@implementation ELSawOscillator

- (id)initEnabled:(BOOL)_enabled_ minimum:(float)_minimum_ maximum:(float)_maximum_ rest:(int)_rest_ attack:(int)_attack_ sustain:(int)_sustain_ decay:(int)_decay_ {
  if( ( self = [super initEnabled:_enabled_ minimum:_minimum_ maximum:_maximum_] ) ) {
    [self setRest:_rest_];
    [self setAttack:_attack_];
    [self setSustain:_sustain_];
    [self setDecay:_decay_];
  }
  
  return self;
}

- (NSString *)type {
  return @"Saw";
}

@dynamic rest;

- (int)rest {
  return rest;
}

- (void)setRest:(int)_rest_ {
  rest = _rest_;
  [self updateBasesAndDeltas];
}

@dynamic attack;

- (int)attack {
  return attack;
}

- (void)setAttack:(int)_attack_ {
  attack = _attack_;
  [self updateBasesAndDeltas];
}

@dynamic sustain;

- (int)sustain {
  return sustain;
}

- (void)setSustain:(int)_sustain_ {
  sustain = _sustain_;
  [self updateBasesAndDeltas];
}

@dynamic decay;

- (int)decay {
  return decay;
}

- (void)setDecay:(int)_decay_ {
  decay = _decay_;
  [self updateBasesAndDeltas];
}

- (void)updateBasesAndDeltas {
  attackBase = rest + attack;
  decayBase = rest + attack + sustain;
  period = rest + attack + sustain + decay;
  
  attackDelta = ( maximum - minimum ) / attack;
  decayDelta = ( maximum - minimum ) / decay;
}

- (float)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 1000000;
    int t = time % period;
    return [self generateWithT:t];
}


- (float)generateWithT:(int)_t_ {
  if( _t_ <= rest ) {
    return minimum;
  } else if( _t_ <= attackBase ) {
    return ( attackDelta * ( _t_ - attackBase ) ) + minimum;
  } else if( _t_ <= decayBase ) {
    return maximum;
  } else {
    return ( decayDelta * ( _t_ - decayBase ) ) + minimum;
  }
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"rest"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'rest' attribute node for oscillator!" );
      return nil;
    } else {
      [self setRest:[[attributeNode stringValue] floatValue]];
    }

    attributeNode = [_representation_ attributeForName:@"attack"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'attack' attribute node for oscillator" );
      return nil;
    } else {
      [self setAttack:[[attributeNode stringValue] floatValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"sustain"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'sustain' attribute node for oscillator" );
      return nil;
    } else {
      [self setAttack:[[attributeNode stringValue] floatValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"decay"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'decay' attribute node for oscillator" );
      return nil;
    } else {
      [self setDecay:[[attributeNode stringValue] floatValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithFloat:[self rest]] forKey:@"rest"];
  [_attributes_ setObject:[NSNumber numberWithFloat:[self attack]] forKey:@"attack"];
  [_attributes_ setObject:[NSNumber numberWithFloat:[self sustain]] forKey:@"sustain"];
  [_attributes_ setObject:[NSNumber numberWithFloat:[self decay]] forKey:@"decay"];
}

@end
