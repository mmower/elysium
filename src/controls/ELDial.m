//
//  ELDial.m
//  Elysium
//
//  Created by Matt Mower on 31/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "limits.h"

#import "ELDial.h"
#import "ELPlayer.h"

#import "ELOscillator.h"
#import "ELOscillatorController.h"

#import "ELDialModeValueTransformer.h"
#import "ELDialHasOscillatorValueTransformer.h"

int randval() {
  return ( random() % 100 ) + 1;
}

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
            player:(ELPlayer *)player
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
    [self setPlayer:player];
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
            player:(ELPlayer *)player
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
                     player:player
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
                     player:[parentDial player]
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
            player:(ELPlayer *)player
          assigned:(int)assigned
               min:(int)min
               max:(int)max
              step:(int)step
{
  return [self initWithMode:dialFree
                       name:name
                    toolTip:toolTip
                        tag:tag
                     player:player
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
                     player:nil
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

- (void)setDelegate:(id)delegate {
  _delegate = delegate;
}


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
        // NSLog( @"Lets bind dial %@ to oscillator %@", self, [self oscillator] );
        // NSLog( @"osc value = %d", [[self oscillator] value] );
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
  
  NSUndoManager *undoManager = [[self player] undoManager];
  if( ![undoManager isUndoing] ) {
    if( [[undoManager undoActionName] isEqualToString:@""] ) {
      [undoManager setActionName:[NSString stringWithFormat:@"set %@ mode",[self name]]];
    }
    [[undoManager prepareWithInvocationTarget:self] setMode:_mode];
  }
  
  _mode = mode;
}


@synthesize name = _name;
@synthesize toolTip = _toolTip;
@synthesize tag = _tag;

@synthesize player = _player;

- (void)setPlayer:(ELPlayer *)player {
  [[[self player] oscillatorController] removeOscillator:[self oscillator]];
  _player = player;
}

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
  if( _oscillator ) {
    [[[self player] oscillatorController] removeOscillator:_oscillator];
  }
  
  NSUndoManager *undoManager = [[self player] undoManager];
  [undoManager beginUndoGrouping];
  [[undoManager prepareWithInvocationTarget:self] setOscillator:_oscillator];
  
  if( ![undoManager isUndoing] ) {
    [undoManager setActionName:[NSString stringWithFormat:@"set %@ LFO",[self name]]];
  }
  
  _oscillator = oscillator;
  
  if( _oscillator ) {
    [[[self player] oscillatorController] addOscillator:_oscillator];
  } else {
    [self setMode:dialFree];
  }
  
  [undoManager endUndoGrouping];
}


@synthesize assigned = _assigned;
@synthesize last = _last;

- (void)setLast:(int)last {
  NSUndoManager *undoManager = [[self player] undoManager];
  if( ![undoManager isUndoing] && [self mode] != dialDynamic ) {
    [[undoManager prepareWithInvocationTarget:self] setLast:_last];
  }
  _last = last;
}

@synthesize value = _value;

- (void)setValue:(int)value {
  if( value < [self min] ) {
    NSLog( @"Attempt to set value %d below minimum %d for dial: %@", value, [self min], self );
    value = [self min];
  } else if( value > [self max] ) {
    NSLog( @"Attempt to set value %d above maximum %d for dial: %@", value, [self max], self );
    value = [self max];
  }
  
  NSUndoManager *undoManager = nil;
  if( [self mode] != dialDynamic ) {
    undoManager = [[self player] undoManager];
  }
  [undoManager beginUndoGrouping];
  [undoManager setActionName:[NSString stringWithFormat:@"set %@ value",[self name]]];
  
  [self setLast:value];
  [(ELDial *)[undoManager prepareWithInvocationTarget:self] setValue:_value];
  _value = value;
  
  [undoManager endUndoGrouping];
  
  if( [[self delegate] respondsToSelector:@selector(dialDidChangeValue:)] ) {
    [[self delegate] dialDidChangeValue:self];
  }
}


@synthesize min = _min;
@synthesize max = _max;
@synthesize step = _step;
@synthesize duplicate = _duplicate;


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
  return [NSString stringWithFormat:@"Dial[ptr=%p,name=%@,min=%d,max=%d,value=%d,step=%d]", self, [self name], [self min], [self max], [self value], [self step]];
}


- (BOOL)pTest {
  return randval() <= [self value];
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
    [self setPlayer:player];
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
      
      // Usually calling -setOscillator: will update the players list of active oscillators
      // however in the load-from-XML case the dial does not have a delegate yet so the
      // player is not updated. We fake it in this case:
      // [player dialDidSetOscillator:self];
    }
    
    // Mode is set last to ensure that parent/oscillator
    // are setup before attempting to switch mode
    [self setMode:[representation attributeAsInteger:@"mode" defaultValue:dialFree]];
    return self;
  } else {
    return nil;
  }
}


#pragma mark Implements NSMutableCopying

- (ELDial *)duplicateDial {
  ELDial *duplicate = [self mutableCopy];
  [duplicate setDuplicate:YES];
  return duplicate;
}


- (id)copyWithZone:(NSZone *)zone {
  return [self mutableCopyWithZone:zone];
}


- (id)mutableCopyWithZone:(NSZone *)zone {
  ELDial * copy = [[[self class] allocWithZone:zone] initWithMode:[self mode]
                                                             name:[self name]
                                                          toolTip:[self toolTip]
                                                              tag:[self tag]
                                                           player:[self player]
                                                           parent:[self parent]
                                                       oscillator:[[self oscillator] mutableCopy]
                                                         assigned:[self assigned]
                                                             last:[self last]
                                                            value:[self value]
                                                              min:[self min]
                                                              max:[self max]
                                                             step:[self step]];
  return copy;
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
