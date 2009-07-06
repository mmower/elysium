//
//  ELSquareOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSquareOscillator.h"

#import "ELOscillator.h"

@implementation ELSquareOscillator

#pragma mark Object initialization

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)rest sustain:(int)sustain {
  if( ( self = [super initEnabled:enabled minimum:minimum maximum:maximum] ) ) {
    [self setRest:rest];
    [self setSustain:sustain];
  }
  
  return self;
}


#pragma mark Properties

@synthesize rest = _rest;

- (void)setRest:(int)rest {
  _rest = rest;
  [self updatePeriod];
}

@synthesize sustain = _sustain;

- (void)setSustain:(int)sustain {
  sustain = sustain;
  [self updatePeriod];
}


#pragma mark Object behaviours

- (NSString *)type {
  return @"Square";
}


- (void)updatePeriod {
  _period = [self rest] + [self sustain];
}


- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() - [self timeBase] ) / 1000000;
    int t = time % _period;
    return [self generateWithT:t];
}


- (int)generateWithT:(int)t {
  if( t < [self sustain] ) {
    return [self minimum];
  } else {
    return [self maximum];
  }
}


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [representation attributeForName:@"rest"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'rest' attribute node for oscillator!" );
      return nil;
    } else {
      [self setRest:[[attributeNode stringValue] intValue]];
    }
    
    attributeNode = [representation attributeForName:@"sustain"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'sustain' attribute node for oscillator" );
      return nil;
    } else {
      [self setSustain:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
  
  [attributes setObject:[NSNumber numberWithFloat:[self rest]] forKey:@"rest"];
  [attributes setObject:[NSNumber numberWithFloat:[self sustain]] forKey:@"sustain"];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                minimum:[self minimum]
                                                maximum:[self maximum]
                                                   rest:[self rest]
                                                sustain:[self sustain]];
}


@end
