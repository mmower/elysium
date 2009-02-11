//
//  ELDial.m
//  Elysium
//
//  Created by Matt Mower on 31/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "limits.h"

#import "ELDial.h"

#import "ELOscillator.h"

#import "ELDialModeValueTransformer.h"
#import "ELDialHasOscillatorValueTransformer.h"

@implementation ELDial

+ (void)initialize {
  [self exposeBinding:@"mode"];
  [self exposeBinding:@"name"];
  [self exposeBinding:@"tag"];
  [self exposeBinding:@"parent"];
  [self exposeBinding:@"oscillator"];
  [self exposeBinding:@"assigned"];
  [self exposeBinding:@"value"];
  [self exposeBinding:@"min"];
  [self exposeBinding:@"max"];
  [self exposeBinding:@"step"];
  
  [NSValueTransformer setValueTransformer:[[ELDialModeValueTransformer alloc] init] forName:dialModeValueTransformer];
  [NSValueTransformer setValueTransformer:[[ELDialHasOscillatorValueTransformer alloc] init] forName:dialHasOscillatorValueTransformer];
}


- (id)initWithMode:(ELDialMode)aMode
              name:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
            parent:(ELDial *)aParent
        oscillator:(ELOscillator *)aOscillator
          assigned:(int)aAssigned
              last:(int)aLast
             value:(int)aValue
               min:(int)aMin
               max:(int)aMax
              step:(int)aStep
{
  if( ( self = [super init] ) ) {
    [self setName:aName];
    [self setToolTip:aToolTip];
    [self setTag:aTag];
    [self setParent:aParent];
    [self setOscillator:aOscillator];
    [self setAssigned:aAssigned];
    [self setLast:aLast];
    [self setValue:aValue];
    [self setMin:aMin];
    [self setMax:aMax];
    [self setStep:aStep];
    
    // Mode is set last to ensure that parent/oscillator
    // are setup before attempting to switch mode
    [self setMode:aMode];
  }
  
  return self;
}


- (id)initWithMode:(ELDialMode)aMode
              name:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
            parent:(ELDial *)aParent
        oscillator:(ELOscillator *)aOscillator
          assigned:(int)aAssigned
              last:(int)aLast
             value:(int)aValue
{
  return [self initWithMode:aMode
                       name:aName
                    toolTip:aToolTip
                        tag:aTag
                     parent:aParent
                 oscillator:aOscillator
                   assigned:aAssigned
                       last:aLast
                      value:aValue
                        min:0
                        max:1
                       step:1];
}


- (id)initWithParent:(ELDial *)parentDial {
  return [self initWithMode:dialInherited
                       name:[parentDial name]
                    toolTip:[parentDial toolTip]
                        tag:[parentDial tag]
                     parent:parentDial
                 oscillator:nil
                   assigned:[parentDial assigned]
                       last:INT_MIN
                      value:[parentDial value]
                        min:[parentDial min]
                        max:[parentDial max]
                       step:[parentDial step]];
}

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
          assigned:(int)aAssigned
               min:(int)aMin
               max:(int)aMax
              step:(int)aStep
{
  return [self initWithMode:dialFree
                       name:aName
                    toolTip:aToolTip
                        tag:aTag
                     parent:nil
                 oscillator:nil
                   assigned:aAssigned
                       last:INT_MIN
                      value:aAssigned
                        min:aMin
                        max:aMax
                       step:aStep];
}

- (id)initWithName:(NSString *)aName
           toolTip:(NSString *)aToolTip
               tag:(int)aTag
         boolValue:(BOOL)aValue
{
  return [self initWithMode:dialFree
                       name:aName
                    toolTip:aToolTip
                        tag:aTag
                     parent:nil
                 oscillator:nil
                   assigned:aValue
                       last:INT_MIN
                      value:aValue
                        min:NO
                        max:YES
                       step:1];
}


@synthesize delegate;

@dynamic mode;

- (ELDialMode)mode {
  return mode;
}


- (void)setMode:(ELDialMode)newMode {
  switch( newMode ) {
    case dialFree:
      [self unbind:@"assigned"];
      [self unbind:@"value"];
      [self bind:@"value" toObject:self withKeyPath:@"assigned" options:nil];
      [self bind:@"assigned" toObject:self withKeyPath:@"value" options:nil];
      break;
      
    case dialDynamic:
      if( oscillator ) {
        [self unbind:@"assigned"];
        [self unbind:@"value"];
        // Note that we expect all current oscillators to have generated a new value
        // at the start of each beat of their layer
        [self bind:@"value" toObject:oscillator withKeyPath:@"value" options:nil];
      }
      break;
    
    case dialInherited:
      if( parent ) {
        [self unbind:@"assigned"];
        [self unbind:@"value"];
        [self bind:@"value" toObject:parent withKeyPath:@"value" options:nil];
      }
      break;
  }
  mode = newMode;
}


@synthesize name;
@synthesize toolTip;
@synthesize tag;

@dynamic parent;

- (ELDial *)parent {
  return parent;
}

- (void)setParent:(ELDial *)newParent {
  if( [self mode] == dialInherited ) {
    [self unbind:@"value"];
  }
  parent = newParent;
  if( [self mode] == dialInherited ) {
    if( parent ) {
      [self bind:@"value" toObject:parent withKeyPath:@"value" options:nil];
    } else {
      [self setMode:dialFree];
    }
  }
}

@dynamic oscillator;

- (ELOscillator *)oscillator {
  return oscillator;
}

- (void)setOscillator:(ELOscillator *)newOscillator {
  if( oscillator && [delegate respondsToSelector:@selector(dialDidUnsetOscillator:)] ) {
    [delegate dialDidUnsetOscillator:self];
  }
  
  oscillator = newOscillator;
  
  if( oscillator ) {
    if( [delegate respondsToSelector:@selector(dialDidSetOscillator:)] ) {
      [delegate dialDidSetOscillator:self];
    }
  } else if( [self mode] == dialDynamic ) {
    [self setMode:dialFree];
  }
}

@synthesize assigned;
@synthesize last;

@dynamic value;

- (int)value {
  return value;
}


- (void)setValue:(int)newValue {
  last = value;
  value = newValue;
  if( [delegate respondsToSelector:@selector(dialDidChangeValue:)] ) {
    [delegate dialDidChangeValue:self];
  }
}

@synthesize min;
@synthesize max;
@synthesize step;

- (BOOL)boolValue {
  return [self value] != 0;
}


- (void)setBoolValue:(BOOL)boolValue {
  [self setValue:(boolValue ? 1 : 0)];
}

- (void)start {
  [oscillator start];
}

- (void)stop {
  [oscillator stop];
}

#pragma mark ELXmlData implementation

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *dialElement = [NSXMLNode elementWithName:@"dial"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[[NSNumber numberWithInteger:mode] stringValue] forKey:@"mode"];
  [attributes setObject:name forKey:@"name"];
  [attributes setObject:[NSNumber numberWithInteger:tag] forKey:@"tag"];
  
  [attributes setObject:[NSNumber numberWithInteger:assigned] forKey:@"assigned"];
  [attributes setObject:[NSNumber numberWithInteger:last] forKey:@"last"];
  [attributes setObject:[NSNumber numberWithInteger:value] forKey:@"value"];
  [attributes setObject:[NSNumber numberWithInteger:min] forKey:@"min"];
  [attributes setObject:[NSNumber numberWithInteger:max] forKey:@"max"];
  [attributes setObject:[NSNumber numberWithInteger:step] forKey:@"step"];
  [dialElement setAttributesAsDictionary:attributes];
  if( oscillator ) {
    [dialElement addChild:[oscillator xmlRepresentation]];
  }
  
  return dialElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ error:(NSError **)_error_ {
  if( _representation_ && ( self = [self init] ) ) {
    [self setName:[_representation_ attributeAsString:@"name"]];
    [self setTag:[_representation_ attributeAsInteger:@"tag" defaultValue:INT_MIN]];
    
    [self setAssigned:[_representation_ attributeAsInteger:@"assigned" defaultValue:INT_MIN]];
    [self setLast:[_representation_ attributeAsInteger:@"last" defaultValue:INT_MIN]];
    [self setValue:[_representation_ attributeAsInteger:@"value" defaultValue:INT_MIN]];
    
    [self setMin:[_representation_ attributeAsInteger:@"min" defaultValue:INT_MIN]];
    [self setMax:[_representation_ attributeAsInteger:@"max" defaultValue:INT_MIN]];
    [self setStep:[_representation_ attributeAsInteger:@"step" defaultValue:INT_MIN]];
    
    [self setParent:_parent_];
    
    // Decode oscillator
    NSXMLElement *oscillatorElement = [[_representation_ nodesForXPath:@"oscillator" error:_error_] firstXMLElement];
    if( oscillatorElement ) {
      [self setOscillator:[ELOscillator loadFromXml:oscillatorElement parent:self player:_player_ error:_error_]];
    }
    
    // Mode is set last to ensure that parent/oscillator
    // are setup before attempting to switch mode
    [self setMode:[_representation_ attributeAsInteger:@"mode" defaultValue:dialFree]];
    return self;
  } else {
    return nil;
  }
}


// NSMutableCopying protocol

- (id)copyWithZone:(NSZone *)_zone_ {
  return [self mutableCopyWithZone:_zone_];
}


- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithMode:[self mode]
                                                      name:[self name]
                                                   toolTip:[self toolTip]
                                                       tag:[self tag]
                                                    parent:[self parent]
                                                oscillator:[self oscillator]
                                                  assigned:[self assigned]
                                                      last:[self last]
                                                     value:[self value]
                                                       min:[self min]
                                                       max:[self max]
                                                      step:[self step]];
}


- (BOOL)isInherited {
  return mode == dialInherited;
}

- (void)setIsInherited:(BOOL)shouldInherit {
  if( shouldInherit ) {
    [self setMode:dialInherited];
  } else {
    [self setMode:dialFree];
  }
}

- (BOOL)isDynamic {
  return mode == dialDynamic;
}

- (void)setIsDynamic:(BOOL)shouldBeDynamic {
  if( shouldBeDynamic ) {
    [self setMode:dialDynamic];
  } else {
    [self setMode:dialFree];
  }
}

@end
