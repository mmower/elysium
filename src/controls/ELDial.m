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


- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value
               min:(int)min
               max:(int)max
              step:(int)step
{
  if( ( self = [super init] ) ) {
    [self setName:name];
    [self setToolTip:toolTip];
    [self setTag:tag];
    [self setParent:parent];
    [self setOscillator:oscillator];
    [self setMin:min];
    [self setMax:max];
    [self setLast:last];
    [self setAssigned:assigned];
    [self setValue:value];
    [self setStep:step];
    
    // Mode is set last to ensure that parent/oscillator
    // are setup before attempting to switch mode
    [self setMode:mode];
  }
  
  return self;
}


- (id)initWithMode:(ELDialMode)mode
              name:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
            parent:(ELDial *)parent
        oscillator:(ELOscillator *)oscillator
          assigned:(int)assigned
              last:(int)last
             value:(int)value
{
  return [self initWithMode:mode
                       name:name
                    toolTip:toolTip
                        tag:tag
                     parent:parent
                 oscillator:oscillator
                   assigned:assigned
                       last:last
                      value:value
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

- (id)initWithName:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
          assigned:(int)assigned
               min:(int)min
               max:(int)max
              step:(int)step
{
  return [self initWithMode:dialFree
                       name:name
                    toolTip:toolTip
                        tag:tag
                     parent:nil
                 oscillator:nil
                   assigned:assigned
                       last:INT_MIN
                      value:assigned
                        min:min
                        max:max
                       step:step];
}

- (id)initWithName:(NSString *)name
           toolTip:(NSString *)toolTip
               tag:(int)tag
         boolValue:(BOOL)value
{
  return [self initWithMode:dialFree
                       name:name
                    toolTip:toolTip
                        tag:tag
                     parent:nil
                 oscillator:nil
                   assigned:value
                       last:INT_MIN
                      value:value
                        min:NO
                        max:YES
                       step:1];
}


@synthesize delegate = _delegate;

@synthesize mode = _mode;

- (void)setMode:(ELDialMode)mode {
  switch( mode ) {
    case dialFree:
      [self unbind:@"assigned"];
      [self unbind:@"value"];
      [self bind:@"value" toObject:self withKeyPath:@"assigned" options:nil];
      [self bind:@"assigned" toObject:self withKeyPath:@"value" options:nil];
      break;
      
    case dialDynamic:
      if( [self oscillator] ) {
        [self unbind:@"assigned"];
        [self unbind:@"value"];
        // Note that we expect all current oscillators to have generated a new value
        // at the start of each beat of their layer
        [self bind:@"value" toObject:[self oscillator] withKeyPath:@"value" options:nil];
      }
      break;
    
    case dialInherited:
      if( [self parent] ) {
        [self unbind:@"assigned"];
        [self unbind:@"value"];
        [self bind:@"value" toObject:[self parent] withKeyPath:@"value" options:nil];
      }
      break;
  }
  _mode = mode;
}


@synthesize name = _name;
@synthesize toolTip = _toolTip;
@synthesize tag = _tag;

@synthesize parent = _parent;

- (void)setParent:(ELDial *)parent {
  if( [self mode] == dialInherited ) {
    [self unbind:@"value"];
  }
  _parent = parent;
  if( [self mode] == dialInherited ) {
    if( _parent ) {
      [self bind:@"value" toObject:_parent withKeyPath:@"value" options:nil];
    } else {
      [self setMode:dialFree];
    }
  }
}


@synthesize oscillator = _oscillator;

- (void)setOscillator:(ELOscillator *)oscillator {
  if( _oscillator && [[self delegate] respondsToSelector:@selector(dialDidUnsetOscillator:)] ) {
    [[self delegate] dialDidUnsetOscillator:self];
  }
  
  _oscillator = oscillator;
  
  if( _oscillator ) {
    if( [[self delegate] respondsToSelector:@selector(dialDidSetOscillator:)] ) {
      [[self delegate] dialDidSetOscillator:self];
    }
  } else if( [self mode] == dialDynamic ) {
    [self setMode:dialFree];
  }
}


@synthesize assigned = _assigned;
@synthesize last = _last;

@synthesize value = _value;

- (void)setValue:(int)value {
  if( value < [self min] ) {
    NSLog( @"Attempt to set value %d below minimum %d for dial: %@", value, [self min], self );
    value = [self min];
  } else if( value > [self max] ) {
    NSLog( @"Attempt to set value %d above maximum %d for dial: %@", value, [self max], self );
    value = [self max];
  }
  
  [self setLast:value];
  _value = value;
  if( [[self delegate] respondsToSelector:@selector(dialDidChangeValue:)] ) {
    [[self delegate] dialDidChangeValue:self];
  }
}


@synthesize min = _min;
@synthesize max = _max;
@synthesize step = _step;

- (BOOL)boolValue {
  return [self value] != 0;
}


- (void)setBoolValue:(BOOL)value {
  [self setValue:(value ? 1 : 0)];
}


- (void)start {
  [[self oscillator] start];
}


- (void)stop {
  [[self oscillator] stop];
}


- (NSString *)description {
  return [NSString stringWithFormat:@"Dial<%@> min:%d max:%d value:%d step:%d", [self name], [self min], [self max], [self value], [self step]];
}


#pragma mark ELXmlData implementation

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *dialElement = [NSXMLNode elementWithName:@"dial"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  [attributes setObject:[[NSNumber numberWithInteger:[self mode]] stringValue] forKey:@"mode"];
  [attributes setObject:[self name] forKey:@"name"];
  [attributes setObject:[NSNumber numberWithInteger:[self tag]] forKey:@"tag"];
  
  [attributes setObject:[NSNumber numberWithInteger:[self assigned]] forKey:@"assigned"];
  [attributes setObject:[NSNumber numberWithInteger:[self last]] forKey:@"last"];
  [attributes setObject:[NSNumber numberWithInteger:[self value]] forKey:@"value"];
  [attributes setObject:[NSNumber numberWithInteger:[self min]] forKey:@"min"];
  [attributes setObject:[NSNumber numberWithInteger:[self max]] forKey:@"max"];
  [attributes setObject:[NSNumber numberWithInteger:[self step]] forKey:@"step"];
  [dialElement setAttributesAsDictionary:attributes];
  if( [self oscillator] ) {
    [dialElement addChild:[[self oscillator] xmlRepresentation]];
  }
  
  return dialElement;
}


- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( representation && ( self = [self init] ) ) {
    [self setName:[representation attributeAsString:@"name"]];
    [self setTag:[representation attributeAsInteger:@"tag" defaultValue:INT_MIN]];
    
    [self setMin:[representation attributeAsInteger:@"min" defaultValue:INT_MIN]];
    [self setMax:[representation attributeAsInteger:@"max" defaultValue:INT_MIN]];
    [self setStep:[representation attributeAsInteger:@"step" defaultValue:INT_MIN]];
    
    [self setAssigned:[representation attributeAsInteger:@"assigned" defaultValue:INT_MIN]];
    [self setLast:[representation attributeAsInteger:@"last" defaultValue:INT_MIN]];
    [self setValue:[representation attributeAsInteger:@"value" defaultValue:INT_MIN]];
    
    [self setParent:parent];
    
    // Decode oscillator
    NSXMLElement *oscillatorElement = [[representation nodesForXPath:@"oscillator" error:error] firstXMLElement];
    if( oscillatorElement ) {
      [self setOscillator:[ELOscillator loadFromXml:oscillatorElement parent:self player:player error:error]];
    }
    
    // Mode is set last to ensure that parent/oscillator
    // are setup before attempting to switch mode
    [self setMode:[representation attributeAsInteger:@"mode" defaultValue:dialFree]];
    return self;
  } else {
    return nil;
  }
}


// NSMutableCopying protocol

- (id)copyWithZone:(NSZone *)zone {
  return [self mutableCopyWithZone:zone];
}


- (id)mutableCopyWithZone:(NSZone *)zone {
  return [[[self class] allocWithZone:zone] initWithMode:[self mode]
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
  return [self mode] == dialInherited;
}


- (void)setIsInherited:(BOOL)inherit {
  if( inherit ) {
    [self setMode:dialInherited];
  } else {
    [self setMode:dialFree];
  }
}


- (BOOL)isDynamic {
  return [self mode] == dialDynamic;
}


- (void)setIsDynamic:(BOOL)dynamic {
  if( dynamic ) {
    [self setMode:dialDynamic];
  } else {
    [self setMode:dialFree];
  }
}

@end
