//
//  ELKnob.m
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELKnob.h"

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
    name = _name_;
    
    // By default we inherit nothing
    hasValue      = NO;
    linkEnabled   = NO;
    linkValue     = NO;
    hasAlpha      = NO;
    linkAlpha     = NO;
    hasP          = NO;
    linkP         = NO;
    filter        = nil;
    linkFilter    = NO;
    predicate     = nil;
    linkPredicate = NO;
  }
  
  return self;
}

- (id)initWithName:(NSString*)_name_
        linkedKnob:(ELKnob*)_knob_
           enabled:(BOOL)_enabled_
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
             alpha:(float)_alpha_
          hasAlpha:(BOOL)_hasAlpha_
         linkAlpha:(BOOL)_linkAlpha_
                 p:(float)_p_
              hasP:(BOOL)_hasP_
             linkP:(BOOL)_linkP_
            filter:(ELOscillator*)_filter_
        linkFilter:(BOOL)_linkFilter_
         predicate:(NSPredicate*)_predicate_
     linkPredicate:(BOOL)_linkPredicate_
{
  if( ( self = [self init] ) ) {
    name          = _name_;
    linkedKnob    = _knob_;
    enabled       = _enabled_;
    hasEnabled    = _hasEnabled_;
    linkEnabled   = _linkEnabled_;
    hasValue      = _hasValue_;
    linkValue     = _linkValue_;
    alpha         = _alpha_;
    hasAlpha      = _hasAlpha_;
    linkAlpha     = _linkAlpha_;
    p             = _p_;
    hasP          = _hasP_;
    linkP         = _linkP_;
    filter        = _filter_;
    linkFilter    = _linkFilter_;
    predicate     = _predicate_;
    linkPredicate = _linkPredicate_;
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

- (float)alpha {
  if( alpha ) {
    return alpha;
  } else if( linkAlpha ) {
    return [linkedKnob alpha];
  } else {
    return 1.0;
  }
}

- (void)setAlpha:(float)_alpha_ {
  hasAlpha = YES;
  alpha    = _alpha_;
}

- (BOOL)linkAlpha {
  return linkAlpha;
}

- (void)setLinkAlpha:(BOOL)_linkAlpha_ {
  linkAlpha = _linkAlpha_;
}

- (float)p {
  if( hasP ) {
    return p;
  } else if( linkP ) {
    return [linkedKnob p];
  } else {
    return 1.0;
  }
}

- (void)setP:(float)_p_ {
  hasP = YES;
  p    = _p_;
}

- (BOOL)linkP {
  return linkP;
}

- (void)setLinkP:(BOOL)_linkP_ {
  linkP = _linkP_;
}

- (ELOscillator *)filter {
  if( filter ) {
    return filter;
  } else if( linkFilter ) {
    return [linkedKnob filter];
  } else {
    return nil;
  }
}

- (void)setFilter:(ELOscillator *)_filter_ {
  filter = _filter_;
}

- (BOOL)linkFilter {
  return linkFilter;
}

- (void)setLinkFilter:(BOOL)_linkFilter_ {
  linkFilter = _linkFilter_;
}

- (NSPredicate *)predicate {
  if( predicate ) {
    return predicate;
  } else if( linkPredicate ) {
    return [linkedKnob predicate];
  } else {
    return nil;
  }
}

- (void)setPredicate:(NSPredicate *)_predicate_ {
  predicate = _predicate_;
}

- (BOOL)linkPredicate {
  return linkPredicate;
}

- (void)setLinkPredicate:(BOOL)_linkPredicate_ {
  linkPredicate = _linkPredicate_;
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

  NSXMLElement *alphaElement = [NSXMLNode elementWithName:@"alpha"];
  attributes = [NSMutableDictionary dictionary];
  if( hasAlpha ) {
    [attributes setObject:[[NSNumber numberWithFloat:alpha] stringValue] forKey:@"current"];
  }
  [attributes setObject:(linkAlpha ? @"YES" : @"NO") forKey:@"linked"];
  [alphaElement setAttributesAsDictionary:attributes];
  [knobElement addChild:alphaElement];
  
  NSXMLElement *pElement = [NSXMLNode elementWithName:@"p"];
  attributes = [NSMutableDictionary dictionary];
  if( hasP ) {
    [attributes setObject:[[NSNumber numberWithFloat:p] stringValue] forKey:@"current"];
  }
  [attributes setObject:(linkP ? @"YES" : @"NO") forKey:@"linked"];
  [pElement setAttributesAsDictionary:attributes];
  [knobElement addChild:pElement];
  
  return knobElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ {
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
    
    // Decode alpha
    
    nodes = [_representation_ nodesForXPath:@"alpha" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    
    attrNode = [element attributeForName:@"current"];
    if( attrNode ) {
      [self setAlpha:[[attrNode stringValue] floatValue]];
    }
    
    attrNode = [element attributeForName:@"linked"];
    [self setLinkEnabled:[[attrNode stringValue] boolValue]];
    
    // Decode p
    
    nodes = [_representation_ nodesForXPath:@"p" error:nil];
    element = (NSXMLElement *)[nodes objectAtIndex:0];
    
    attrNode = [element attributeForName:@"current"];
    if( attrNode ) {
      [self setAlpha:[[attrNode stringValue] floatValue]];
      
    }
    
    attrNode = [element attributeForName:@"linked"];
    [self setLinkP:[[attrNode stringValue] boolValue]];
  }
  
  return self;
}

@end
