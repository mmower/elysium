//
//  ELKnob.m
//  Elysium
//
//  Created by Matt Mower on 10/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
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

- (id)init {
  @throw [NSException exceptionWithName:@"KnobException" reason:@"Unnamed init called on ELKnob." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
}

- (id)initWithName:(NSString *)_name_ {
  if( ( self = [super init] ) ) {
    name       = _name_;
    tag        = -1;
    enabled    = YES;
    linkValue  = NO;
    oscillator = nil;
  }
  
  return self;
}

@synthesize oscillatorController;

- (id)initWithName:(NSString *)_name_
        linkedKnob:(ELKnob *)_knob_
           enabled:(BOOL)_enabled_
         linkValue:(BOOL)_linkValue_
        oscillator:(ELOscillator *)_oscillator_
{
  if( ( self = [self initWithName:_name_] ) ) {
    linkedKnob = _knob_;
    enabled    = _enabled_;
    linkValue  = _linkValue_;
    oscillator = _oscillator_;
  }
  
  return self;
}

@synthesize name;
@synthesize tag;

@dynamic xmlType;

- (NSString *)xmlType {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

@dynamic typeName;

- (NSString *)typeName {
  return @"unknown";
}

@dynamic stringValue;

- (NSString *)stringValue {
  [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self doesNotRecognizeSelector:_cmd];
}

- (BOOL)encodesType:(char *)_type_ {
  return NO;
}

@dynamic enabled;

- (BOOL)enabled {
  if( linkValue ) {
    return [linkedKnob enabled];
  } else {
    return enabled;
  }
}

- (void)setEnabled:(BOOL)_enabled_ {
  enabled    = _enabled_;
}

@synthesize linkedKnob;

@synthesize linkValue;

@synthesize oscillator;

- (void)start {
  [oscillator resetTimeBase];
}

// ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

  NSXMLElement *knobElement = [NSXMLNode elementWithName:@"knob"];
  [attributes setObject:[self xmlType] forKey:@"type"];
  [attributes setObject:name forKey:@"name"];
  if( tag != -1 ) {
    [attributes setObject:[NSNumber numberWithInteger:tag] forKey:@"tag"];
  }
  [attributes setObject:[[NSNumber numberWithBool:enabled] stringValue] forKey:@"enabled"];
  [attributes setObject:[[NSNumber numberWithBool:linkValue] stringValue] forKey:@"inherit"];
  [attributes setObject:[self stringValue] forKey:@"value"];
  [knobElement setAttributesAsDictionary:attributes];
  if( oscillator ) {
    [knobElement addChild:[oscillator xmlRepresentation]];
  }
  
  return knobElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( ( self = [self initWithName:[[_representation_ attributeForName:@"name"] stringValue]] ) ) {
    NSArray *nodes;
    NSXMLElement *element;
    NSXMLNode *attrNode;

    attrNode = [_representation_ attributeForName:@"tag"];
    if( attrNode ) {
      [self setTag:[[attrNode stringValue] integerValue]];
    }
    
    attrNode = [_representation_ attributeForName:@"value"];
    if( !attrNode ) {
      *_error_ = [[NSError alloc] initWithDomain:ELErrorDomain code:EL_ERR_KNOB_MISSING_VALUE userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Missing value for knob %@",[self name]],NSLocalizedDescriptionKey,nil]];
      return nil;
    } else {
      [self setValueWithString:[attrNode stringValue]];
    }
    
    [self setLinkedKnob:_parent_];
    
    attrNode = [_representation_ attributeForName:@"enabled"];
    if( attrNode ) {
      [self setEnabled:[[attrNode stringValue] boolValue]];
    } else {
      [self setEnabled:YES];
    }
    
    attrNode = [_representation_ attributeForName:@"inherit"];
    if( attrNode ) {
      [self setLinkValue:[[attrNode stringValue] boolValue]];
    } else {
      [self setLinkValue:NO];
    }
    
    // Decode oscillator
    nodes = [_representation_ nodesForXPath:@"oscillator" error:nil];
    if( [nodes count] > 0 ) {
      element = (NSXMLElement *)[nodes objectAtIndex:0];
      [self setOscillator:[ELOscillator loadFromXml:element parent:self player:_player_ error:_error_]];
    }
  }
  
  return self;
}

@end
