//
//  ELFilter.m
//  Elysium
//
//  Created by Matt Mower on 08/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "ELFilter.h"
#import "ELSquareFilter.h"
#import "ELSawFilter.h"
#import "ELSineFilter.h"

@implementation ELFilter

- (id)initEnabled:(BOOL)_enabled_ {
  if( ( self = [super init] ) ) {
    [self setEnabled:_enabled_];
  }
  
  return self;
}

@synthesize enabled;

- (NSString *)type {
  return @"filter";
}

- (float)generate {
  @throw [NSException exceptionWithName:@"FilterException"
                                 reason:@"Filter#generate should never be called"
                               userInfo:[NSDictionary dictionaryWithObject:self forKey:@"filter"]];
}

// Implement the ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *filterElement = [NSXMLNode elementWithName:@"filter"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [filterElement setAttributesAsDictionary:attributes];
  
  return filterElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  NSXMLNode *attributeNode = [_representation_ attributeForName:@"type"];
  Class filterClass = NSClassFromString( [NSString stringWithFormat:@"EL%@Filter", [attributeNode stringValue]] );
  return [[filterClass alloc] initWithXmlRepresentation:_representation_ parent:_parent_ player:_player_];
}

@end
