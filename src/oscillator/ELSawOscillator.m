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

- (id)initEnabled:(BOOL)aEnabled minimum:(int)aMin maximum:(int)aMax rest:(int)aRest attack:(int)aAttack sustain:(int)aSustain decay:(int)aDecay {
  if( ( self = [super initEnabled:aEnabled minimum:aMin maximum:aMax] ) ) {
    [self setAttack:aAttack];
    [self setDecay:aDecay];
    [self setRest:aRest];
    [self setSustain:aSustain];
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

- (void)setRest:(int)newRest {
  rest = newRest;
  [self updateBasesAndDeltas];
}

@dynamic attack;

- (int)attack {
  return attack;
}

- (void)setAttack:(int)newAttack {
  attack = newAttack;
  [self updateBasesAndDeltas];
}

@dynamic sustain;

- (int)sustain {
  return sustain;
}

- (void)setSustain:(int)newSustain {
  sustain = newSustain;
  [self updateBasesAndDeltas];
}

@dynamic decay;

- (int)decay {
  return decay;
}

- (void)setDecay:(int)newDecay {
  decay = newDecay;
  [self updateBasesAndDeltas];
}

- (void)updateBasesAndDeltas {
  period = rest + attack + sustain + decay;
  
  if( attack > 0 ) {
    attackDelta = ( maximum - minimum ) / (float)attack;
  }
  if( decay > 0 ) {
    decayDelta = ( maximum - minimum ) / (float)decay;
  }
}

- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % period;
    return [self generateWithT:t];
}


- (int)generateWithT:(int)t {
  if( t <= attack ) {
    return ( attackDelta * t ) + minimum;
  } else if( t <= ( attack + sustain ) ) {
    return maximum;
  } else if( t <= ( attack + sustain + decay ) ) {
    return maximum - ( decayDelta * ( t - ( attack + sustain ) ) );
  } else {
    return minimum;
  }
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"rest"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'rest' attribute node for oscillator!" );
      return nil;
    } else {
      [self setRest:[[attributeNode stringValue] intValue]];
    }

    attributeNode = [_representation_ attributeForName:@"attack"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'attack' attribute node for oscillator" );
      return nil;
    } else {
      [self setAttack:[[attributeNode stringValue] intValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"sustain"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'sustain' attribute node for oscillator" );
      return nil;
    } else {
      [self setAttack:[[attributeNode stringValue] intValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"decay"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'decay' attribute node for oscillator" );
      return nil;
    } else {
      [self setDecay:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithInteger:[self rest]] forKey:@"rest"];
  [_attributes_ setObject:[NSNumber numberWithInteger:[self attack]] forKey:@"attack"];
  [_attributes_ setObject:[NSNumber numberWithInteger:[self sustain]] forKey:@"sustain"];
  [_attributes_ setObject:[NSNumber numberWithInteger:[self decay]] forKey:@"decay"];
}

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                                  maximum:[self maximum]
                                                     rest:[self rest]
                                                   attack:[self attack]
                                                  sustain:[self sustain]
                                                    decay:[self decay]];
}

@end
