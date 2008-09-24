//
//  ELFilter.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELFilter.h"

NSArray const *ELFilterFunctions;

@implementation ELFilter

+ (void)initialize {
  if( !ELFilterFunctions ) {
    ELFilterFunctions = [[NSArray alloc] initWithObjects:@"Sine",nil];
  }
}

- (id)initWithName:(NSString *)_name_ function:(NSString *)_function_ variance:(float)_variance_ period:(float)_period_ {
  if( ( self = [self init] ) ) {
    name         = _name_;
    function     = _function_;
    variance = _variance_;
    period   = _period_;
  }
  
  return self;
}

@synthesize name;
@synthesize function;
@synthesize variance;
@synthesize period;

- (NSString *)description {
  return name;
}

- (float)generate {
  // Get time in tenths of a second
  UInt64 time = AudioConvertHostTimeToNanos( AudioGetCurrentHostTime() ) / 100000000;
  
  // Find out where we are in the cycle
  time = time % (int)( period * 10 );
  
  float t = time / 10.0;
  
  return [self generateWithT:t];
}

- (float)generateWithT:(float)_t_ {
  if( !evalFunction ) {
    
    SEL sel = NSSelectorFromString( [NSString stringWithFormat:@"generate%@WithT:", function] );
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:sel];
    
    evalFunction = [NSInvocation invocationWithMethodSignature:sig];
    [evalFunction setTarget:self];
    [evalFunction setSelector:sel];

    NSAssert1( evalFunction, @"Unable to obtain SEL for filter function! (%@)", function );
  }
  
  [evalFunction setArgument:&_t_ atIndex:2];
  [evalFunction invoke];
  
  float result;
  [evalFunction getReturnValue:&result];
  return result;
}

- (float)generateSineWithT:(float)_t_ {
  // Convert to angular form
  float angle = (_t_ / period) * 2 * M_PI * variance;
  
  // Get the sinewave value
  return (1+sin(angle))/2;
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *filterElement = [NSXMLNode elementWithName:@"filter"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:name forKey:@"name"];
  [attributes setObject:function forKey:@"function"];
  [attributes setObject:[[NSNumber numberWithFloat:variance] stringValue] forKey:@"variance"];
  [attributes setObject:[[NSNumber numberWithFloat:period] stringValue] forKey:@"period"];
  [filterElement setAttributesAsDictionary:attributes];
  
  return filterElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [super init] ) ) {
    
    NSXMLNode *attributeNode;
    
    attributeNode = [_representation_ attributeForName:@"name"];
    name = [attributeNode stringValue];
    
    attributeNode = [_representation_ attributeForName:@"function"];
    function = [attributeNode stringValue];
    
    attributeNode = [_representation_ attributeForName:@"variance"];
    variance = [[attributeNode stringValue] floatValue];
    
    attributeNode = [_representation_ attributeForName:@"period"];
    period = [[attributeNode stringValue] floatValue];
  }
  
  return self;
}

@end
