//
//  ELRangedOscillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELRangedOscillator.h"

@implementation ELRangedOscillator

#pragma mark Object initialization

- (id)initEnabled:(BOOL)enabled minimum:(int)min maximum:(int)max {
  if( ( self = [super initEnabled:enabled] ) ) {
    [self setMinimum:min];
    [self setHardMinimum:min];
    [self setMaximum:max];
    [self setHardMaximum:max];
  }
  
  return self;
}


#pragma mark Properties

@synthesize minimum = _minimum;

- (void)setMinimum:(int)newMinimum {
  _minimum = newMinimum;
  _range = [self maximum] - _minimum;
}


@synthesize hardMinimum = _hardMinimum;


@synthesize maximum = _maximum;

- (void)setMaximum:(int)newMaximum {
  _maximum = newMaximum;
  _range = _maximum - [self minimum];
}


@synthesize hardMaximum = _hardMaximum;


@synthesize range = _range;


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [representation attributeForName:@"minimum"];
    if( attributeNode == nil ) {
      if( *error ) {
        *error = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_OSCILLATOR_INVALID_ATTR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Ranged oscillator has no or invalid minimum",NSLocalizedDescriptionKey,nil]];
      }
      return nil;
    } else {
      [self setMinimum:[[attributeNode stringValue] intValue]];
    }
    
    attributeNode = [representation attributeForName:@"maximum"];
    if( attributeNode == nil ) {
      if( *error ) {
        *error = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_OSCILLATOR_INVALID_ATTR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Ranged oscillator has no or invalid maximum",NSLocalizedDescriptionKey,nil]];
      }
      return nil;
    } else {
      [self setMaximum:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}


- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
  
  [attributes setObject:[NSNumber numberWithInteger:[self minimum]] forKey:@"minimum"];
  [attributes setObject:[NSNumber numberWithInteger:[self maximum]] forKey:@"maximum"];
}


@end
