//
//  ELOscillator.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELOscillator.h"
#import "ELSquareOscillator.h"
#import "ELSawOscillator.h"
#import "ELSineOscillator.h"

@implementation ELOscillator

+ (ELOscillator *)loadFromXml:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  NSXMLNode *attributeNode = [_representation_ attributeForName:@"type"];
  if( attributeNode ) {
    Class oscillatorClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Oscillator", [attributeNode stringValue]] );
    return [[oscillatorClass alloc] initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_ error:_error_];
  } else {
    return nil;
  }
}

- (id)initEnabled:(BOOL)_enabled_ {
  if( ( self = [super init] ) ) {
    [self setEnabled:_enabled_];
    [self resetTimeBase];
  }
  
  return self;
}

@synthesize enabled;
@synthesize timeBase;

- (void)resetTimeBase {
  [self setTimeBase:AudioGetCurrentHostTime()];
}

- (NSString *)type {
  return @"oscillator";
}

- (float)generate {
  @throw [NSException exceptionWithName:@"OscillatorException"
                                 reason:@"Oscillator#generate should never be called"
                               userInfo:[NSDictionary dictionaryWithObject:self forKey:@"oscillator"]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *oscillatorElement = [NSXMLNode elementWithName:@"oscillator"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[self type] forKey:@"type"];
  [self storeAttributes:attributes];
  [oscillatorElement setAttributesAsDictionary:attributes];
  
  return oscillatorElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  NSXMLNode *attributeNode = [_representation_ attributeForName:@"enabled"];
  if( attributeNode ) {
    return [self initEnabled:[[attributeNode stringValue] boolValue]];
  } else {
    return [self initEnabled:YES];
  }
}

- (void)storeAttributes:(NSMutableDictionary *)_attributes_ {
  [_attributes_ setObject:[NSNumber numberWithBool:[self enabled]] forKey:@"enabled"];
}

@end
