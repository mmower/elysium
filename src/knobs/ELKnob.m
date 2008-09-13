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
    
    // By default we inherit everything from any linked knob
    hasValue      = NO;
    linkEnabled   = YES;
    linkValue     = YES;
    linkAlpha     = YES;
    linkP         = YES;
    linkFilter    = YES;
    linkPredicate = YES;
  }
  
  return self;
}

- (NSString *)name {
  return name;
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
  linkValue = _linkValue_;
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

// Implementing the ELData protocol for save/load from XML

// - (NSXMLElement *)asXMLData {
//   NSMutableDictionary *attributes;
//   
//   NSXMLElement *knobElement = [NSXMLNode elementWithName:@"knob"];
//   
//   attributes = [[NSMutableDictionary alloc] init];
//   [attributes setObject:[self typeName] forKey:@"type"];
//   [attributes setObject:name forKey:@"name"];
//   [knobElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   
//   NSXMLElement *dataElement;
//   
//   dataElement = [NSXMLNode elementWithName:@"enabled"];
//   if( enabled ) {
//     [attributes setObject:[enabled stringValue] forKey:@"value"];
//   }
//   [attributes setObject:[[NSNumber numberWithBool:linkEnabled] stringValue] forKey:@"linked"];
//   [dataElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   [knobElement addChild:dataElement];
//   
//   dataElement = [NSXMLNode elementWithName:@"value"];
//   if( hasValue ) {
//     switch( type ) {
//       case INTEGER_KNOB:
//         [attributes setObject:[[NSNumber numberWithInt:intValue] stringValue] forKey:@"integer"];
//         break;
//         
//       case FLOAT_KNOB:
//         [attributes setObject:[[NSNumber numberWithFloat:floatValue] stringValue] forKey:@"float"];
//         break;
//         
//       case BOOLEAN_KNOB:
//         [attributes setObject:[[NSNumber numberWithBool:floatValue] stringValue] forKey:@"bool"];
//         break;
//     }
//   }
//   [attributes setObject:[[NSNumber numberWithBool:linkValue] stringValue] forKey:@"linked"];
//   [dataElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   
//   [knobElement addChild:dataElement];
//   
//   dataElement = [NSXMLNode elementWithName:@"alpha"];
//   if( alpha ) {
//     [attributes setObject:[alpha stringValue] forKey:@"value"];
//   }
//   [attributes setObject:[[NSNumber numberWithBool:linkAlpha] stringValue] forKey:@"linked"];
//   [dataElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   [knobElement addChild:dataElement];
//   
//   dataElement = [NSXMLNode elementWithName:@"p"];
//   if( p ) {
//     [attributes setObject:[p stringValue] forKey:@"value"];
//   }
//   [attributes setObject:[[NSNumber numberWithBool:linkP] stringValue] forKey:@"linked"];
//   [dataElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   [knobElement addChild:dataElement];
//   
//   dataElement = [NSXMLNode elementWithName:@"filter"];
//   if( filter ) {
//     [attributes setObject:[filter name] forKey:@"name"];
//   }
//   [attributes setObject:[[NSNumber numberWithBool:linkFilter] stringValue] forKey:@"linked"];
//   [dataElement setAttributesAsDictionary:attributes];
//   [attributes removeAllObjects];
//   [knobElement addChild:dataElement];
//   
//   return knobElement;
// }
// 
// - (BOOL)fromXMLData:(NSXMLElement *)_data_ {
//   return YES;
// }

@end
