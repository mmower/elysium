//
//  ELOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <CoreAudio/CoreAudio.h>

#import "ELOscillator.h"
#import "ELSquareOscillator.h"
#import "ELSawOscillator.h"
#import "ELSineOscillator.h"

@implementation ELOscillator

#pragma mark Class initializer

+ (ELOscillator *)loadFromXml:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  NSXMLNode *attributeNode = [representation attributeForName:@"type"];
  if( attributeNode ) {
    Class oscillatorClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Oscillator", [attributeNode stringValue]] );
    return [[oscillatorClass alloc] initWithXmlRepresentation:representation parent:parent player:player error:error];
  } else {
    return nil;
  }
}


#pragma mark Object initializer

- (id)initEnabled:(BOOL)enabled {
  if( ( self = [super init] ) ) {
    [self setEnabled:enabled];
    [self resetTimeBase];
  }
  
  return self;
}


#pragma mark Properties

@synthesize enabled = _enabled;
@synthesize timeBase = _timeBase;
@synthesize value = _value;


#pragma mark Object behaviours

- (void)start {
  [self resetTimeBase];
}


- (void)stop {
  
}


- (void)update {
  [self setValue:[self generate]];
}


- (void)resetTimeBase {
  [self setTimeBase:AudioGetCurrentHostTime()];
}


- (NSString *)type {
  return @"oscillator";
}


- (int)generate {
  @throw [NSException exceptionWithName:@"OscillatorException"
                                 reason:@"Oscillator#generate should never be called"
                               userInfo:[NSDictionary dictionaryWithObject:self forKey:@"oscillator"]];
}


#pragma mark Implements ELXmlData

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *oscillatorElement = [NSXMLNode elementWithName:@"oscillator"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[self type] forKey:@"type"];
  [self storeAttributes:attributes];
  [oscillatorElement setAttributesAsDictionary:attributes];
  
  return oscillatorElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  NSXMLNode *attributeNode = [representation attributeForName:@"enabled"];
  if( attributeNode ) {
    return [self initEnabled:[[attributeNode stringValue] boolValue]];
  } else {
    return [self initEnabled:YES];
  }
}


- (void)storeAttributes:(NSMutableDictionary *)attributes {
  [attributes setObject:[NSNumber numberWithBool:[self enabled]] forKey:@"enabled"];
}

@end
