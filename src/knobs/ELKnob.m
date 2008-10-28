//
//  ELKnob.m
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELKnob.h"

#import "ElysiumDocument.h"

#import "ELOscillator.h"

//
// An ELKnob instance represents something controllable in the
// interface although it is not, in itself, a UI control. For
// example the velocity value for a note tool is represented
// by a knob with a type, value, a linked knob (that it might
// inherit from), filters, predicates, and so on.
//

@implementation ELKnob

- (id)initWithName:(NSString *)_name_ {
  if( ( self = [self init] ) ) {
    name        = _name_;
    
    // By default we inherit nothing
    hasValue    = NO;
    linkEnabled = NO;
    linkValue   = NO;
    oscillator  = nil;
  }
  
  return self;
}

@synthesize oscillatorController;

- (id)initWithName:(NSString *)_name_
        linkedKnob:(ELKnob *)_knob_
           enabled:(BOOL)_enabled_
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [self init] ) ) {
    name            = _name_;
    linkedKnob      = _knob_;
    enabled         = _enabled_;
    hasEnabled      = _hasEnabled_;
    linkEnabled     = _linkEnabled_;
    hasValue        = _hasValue_;
    linkValue       = _linkValue_;
    oscillator      = _oscillator_;
  }
  
  return self;
}

- (NSString *)name {
  return name;
}

- (NSString *)xmlType {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (NSString *)stringValue {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self doesNotRecognizeSelector:_cmd];
}

- (void)clearValue {
  hasValue = NO;
}

- (NSString *)typeName {
  return @"unknown";
}

- (BOOL)encodesType:(char *)_type_ {
  return NO;
}

- (BOOL)enabled {
  NSAssert( hasEnabled || linkEnabled, @"Enabled must be either defined or linked!" );
  
  if( hasEnabled ) {
    return enabled;
  } else if( linkEnabled ) {
    return [linkedKnob enabled];
  } else {
    abort();
  }
}

- (void)setEnabled:(BOOL)_enabled_ {
  hasEnabled = YES;
  enabled    = _enabled_;
}

- (BOOL)linkEnabled {
  return linkEnabled;
}

- (void)setLinkEnabled:(BOOL)_linkEnabled_ {
  linkEnabled = _linkEnabled_;
}

- (ELKnob *)linkedKnob {
  return linkedKnob;
}

- (void)setLinkedKnob:(ELKnob *)_linkedKnob_ {
  linkedKnob = _linkedKnob_;
}

- (BOOL)linkValue {
  return linkValue;
}

- (void)setLinkValue:(BOOL)_linkValue_ {
  [self willChangeValueForKey:@"value"];
  linkValue = _linkValue_;
  [self didChangeValueForKey:@"value"];
}

- (ELOscillator *)oscillator {
  return oscillator;
}

- (void)setOscillator:(ELOscillator *)_oscillator_ {
  oscillator = _oscillator_;
}

// ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *knobElement = [NSXMLNode elementWithName:@"knob"];
  
  NSMutableDictionary *attributes = nil;
  
  attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[self xmlType] forKey:@"type"];
  [attributes setObject:name forKey:@"name"];
  [knobElement setAttributesAsDictionary:attributes];
  
  NSXMLElement *valueElement = [NSXMLNode elementWithName:@"value"];
  attributes = [NSMutableDictionary dictionary];
  if( hasValue ) {
    [attributes setObject:[self stringValue] forKey:@"current"];
  }
  [attributes setObject:(linkValue ? @"YES" : @"NO") forKey:@"linked"];
  [valueElement setAttributesAsDictionary:attributes];
  [knobElement addChild:valueElement];
  
  NSXMLElement *enabledElement = [NSXMLNode elementWithName:@"enabled"];
  attributes = [NSMutableDictionary dictionary];
  if( hasEnabled ) {
    [attributes setObject:(enabled ? @"YES" : @"NO") forKey:@"current"];
  }
  [attributes setObject:(linkEnabled ? @"YES" : @"NO") forKey:@"linked"];
  [enabledElement setAttributesAsDictionary:attributes];
  [knobElement addChild:enabledElement];

  if( oscillator ) {
    [knobElement addChild:[oscillator xmlRepresentation]];
  }
  
  return knobElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self initWithName:[[_representation_ attributeForName:@"name"] stringValue]] ) ) {
    NSArray *nodes;
    NSXMLElement *element;
    NSXMLNode *attrNode;
    
    [self setLinkedKnob:_parent_];  
    
    // Decode value
    
    nodes = [_representation_ nodesForXPath:@"value" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    
    attrNode = [element attributeForName:@"current"];
    if( attrNode ) {
      [self setValueWithString:[attrNode stringValue]];
    }
    
    attrNode = [element attributeForName:@"linked"];
    [self setLinkValue:[[attrNode stringValue] boolValue]];
    
    // Decode enabled
    
    nodes = [_representation_ nodesForXPath:@"enabled" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    
    attrNode = [element attributeForName:@"current"];
    if( attrNode ) {
      [self setEnabled:[[attrNode stringValue] boolValue]];
    }
    
    attrNode = [element attributeForName:@"linked"];
    [self setLinkEnabled:[[attrNode stringValue] boolValue]];
    
    // Decode oscillator
    
    nodes = [_representation_ nodesForXPath:@"oscillator" error:nil];
    if( [nodes count] > 0 ) {
      NSLog( @"found oscillator element");
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      [self setOscillator:[ELOscillator loadFromXml:element parent:self player:_player_]];
    }
  }
  
  return self;
}

@end
