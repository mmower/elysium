//
//  ELSequencescillator.m
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSequenceOscillator.h"


@implementation ELSequenceValue

#pragma mark Object initialization

- (id)initWithStringValue:(NSString *)stringValue {
  if( ( self = [super init] ) ) {
    [self setStringValue:stringValue];
  }
  
  return self;
}


#pragma mark Properties

@synthesize intValue = _intValue;

- (void)setIntValue:(int)intValue {
  _intValue = intValue;
  [self willChangeValueForKey:@"stringValue"];
  _stringValue = [[NSNumber numberWithInteger:intValue] stringValue];
  [self didChangeValueForKey:@"stringValue"];
}


@synthesize stringValue = _stringValue;

- (void)setStringValue:(NSString *)stringValue {
  _stringValue = stringValue;
  [self willChangeValueForKey:@"intValue"];
  _intValue = [stringValue intValue];
  [self didChangeValueForKey:@"intValue"];
}


@end


@implementation ELSequenceOscillator

#pragma mark Object initialization

- (id)initEnabled:(BOOL)enabled values:(NSArray *)values {
  if( ( self = [super initEnabled:enabled] ) ) {
    [self setValues:[values mutableCopy]];
    _index  = 0;
  }
  
  return self;
}


#pragma mark Properties

@synthesize values = _values;


#pragma mark Object behaviours

- (NSString *)type {
  return @"Sequence";
}


- (int)generate {
  if( [[self values] count] < 1 ) {
    @throw [NSException exceptionWithName:@"OscillatorException" reason:@"SequenceOscillator has no values" userInfo:[NSDictionary dictionaryWithObject:self forKey:@"oscillator"]];
  }
  
  int generatedValue = [[[self values] objectAtIndex:_index] intValue];
  
  _index += 1;
  if( _index == [[self values] count] ) {
    _index = 0;
  }
  
  return generatedValue;
}


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [super initWithXmlRepresentation:representation parent:parent player:player error:error] ) ) {
    NSXMLNode *attributeNode;
    
    attributeNode = [representation attributeForName:@"values"];
    if( !attributeNode ) {
      NSLog( @"No or invalid 'values' attribute node for oscillator!" );
      return nil;
    } else {
      NSArray *terms = [[attributeNode stringValue] componentsSeparatedByString:@","];
      NSMutableArray *sequenceValues = [[NSMutableArray alloc] init];
      
      for( NSString *term in terms ) {
        [sequenceValues addObject:[[ELSequenceValue alloc] initWithStringValue:term]];
      }
      
      [self setValues:sequenceValues];
    }
  }
  
  return self;
}

- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [super storeAttributes:attributes];
  
  [attributes setObject:[[self values] componentsJoinedByString:@","] forKey:@"values"];
}


#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                 values:[[self values] mutableCopy]];
}


@end
