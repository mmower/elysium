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

- (id)initEnabled:(BOOL)aEnabled minimum:(int)aMin maximum:(int)aMax {
  if( ( self = [super initEnabled:aEnabled] ) ) {
    [self setMinimum:aMin];
    [self setMaximum:aMax];
  }
  
  return self;
}

@dynamic minimum;

- (int)minimum {
  return minimum;
}

- (void)setMinimum:(int)newMinimum {
  minimum = newMinimum;
  range = maximum - minimum;
}

@dynamic maximum;

- (int)maximum {
  return maximum;
}

- (void)setMaximum:(int)newMaximum {
  maximum = newMaximum;
  range = maximum - minimum;
}

@synthesize range;

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [super initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"minimum"];
    if( attributeNode == nil ) {
      *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_OSCILLATOR_INVALID_ATTR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Ranged oscillator has no or invalid minimum",NSLocalizedDescriptionKey,nil]];
      return nil;
    } else {
      [self setMinimum:[[attributeNode stringValue] intValue]];
    }
    
    attributeNode = [_representation_ attributeForName:@"maximum"];
    if( attributeNode == nil ) {
      *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_OSCILLATOR_INVALID_ATTR userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"Ranged oscillator has no or invalid maximum",NSLocalizedDescriptionKey,nil]];
      return nil;
    } else {
      [self setMaximum:[[attributeNode stringValue] intValue]];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [super storeAttributes:_attributes_];
  
  [_attributes_ setObject:[NSNumber numberWithInteger:[self minimum]] forKey:@"minimum"];
  [_attributes_ setObject:[NSNumber numberWithInteger:[self maximum]] forKey:@"maximum"];
}

@end
