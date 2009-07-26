//
//  ELScriptPackage.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELScriptPackage.h"

#import "ELPlayer.h"
#import "ELTimerCallback.h"

@implementation ELScriptPackage

- (id)initWithPlayer:(ELPlayer *)player {
  if( ( self = [super init] ) ) {
    _player = player;
    
    for( int i = 0; i < 8; i++ ) {
      _flag[i]   = NO;
      _var[i]    = 0.0;
      _varMin[i] = 0.0;
      _varMax[i] = 127.0;
    }
    
    for( int i = 0; i < 4; i++ ) {
      _timer[i] = [[ELTimerCallback alloc] initWithPlayer:_player];
    }
  }
  
  return self;
}

@synthesize player = _player;

@dynamic f1;

- (BOOL)f1 {
  return _flag[0];
}

- (void)setF1:(BOOL)set {
  _flag[0] = set;
}

@dynamic f2;

- (BOOL)f2 {
  return _flag[1];
}

- (void)setF2:(BOOL)set {
  _flag[1] = set;
}

@dynamic f3;

- (BOOL)f3 {
  return _flag[2];
}

- (void)setF3:(BOOL)set {
  _flag[2] = set;
}

@dynamic f4;

- (BOOL)f4 {
  return _flag[3];
}

- (void)setF4:(BOOL)set {
  _flag[3] = set;
}

@dynamic f5;

- (BOOL)f5 {
  return _flag[4];
}

- (void)setF5:(BOOL)set {
  _flag[4] = set;
}

@dynamic f6;

- (BOOL)f6 {
  return _flag[5];
}

- (void)setF6:(BOOL)set {
  _flag[5] = set;
}

@dynamic f7;

- (BOOL)f7 {
  return _flag[6];
}

- (void)setF7:(BOOL)set {
  _flag[6] = set;
}

@dynamic f8;

- (BOOL)f8 {
  return _flag[7];
}

- (void)setF8:(BOOL)set {
  _flag[7] = set;
}

@dynamic v1;

- (float)v1 {
  return _var[0];
}

- (void)setV1:(float)var {
  _var[0] = var;
}

@dynamic v1min;

- (float)v1min {
  return _varMin[0];
}

- (void)setV1min:(float)min {
  _varMin[0] = min;
  if( _var[0] < min ) {
    [self setV1:min];
  }
}

@dynamic v1max;

- (float)v1max {
  return _varMax[0];
}

- (void)setV1max:(float)max {
  _varMax[0] = max;
  if( _var[0] > max ) {
    [self setV1:max];
  }
}

@dynamic v2;

- (float)v2 {
  return _var[1];
}

- (void)setV2:(float)var {
  _var[1] = var;
}

@dynamic v2min;

- (float)v2min {
  return _varMin[1];
}

- (void)setV2min:(float)min {
  _varMin[1] = min;
  if( _var[1] < min ) {
    [self setV2:min];
  }
}

@dynamic v2max;

- (float)v2max {
  return _varMax[1];
}

- (void)setV2max:(float)max {
  _varMax[1] = max;
  if( _var[1] > max ) {
    [self setV2:max];
  }
}

@dynamic v3;

- (float)v3 {
  return _var[2];
}

- (void)setV3:(float)var {
  _var[2] = var;
}

@dynamic v3min;

- (float)v3min {
  return _varMin[2];
}

- (void)setV3min:(float)min {
  _varMin[2] = min;
  if( _var[2] < min ) {
    [self setV3:min];
  }
}

@dynamic v3max;

- (float)v3max {
  return _varMax[2];
}

- (void)setV3max:(float)max {
  _varMax[2] = max;
  if( _var[2] > max ) {
    [self setV3:max];
  }
}

@dynamic v4;

- (float)v4 {
  return _var[3];
}

- (void)setV4:(float)var {
  _var[3] = var;
}

@dynamic v4min;

- (float)v4min {
  return _varMin[3];
}

- (void)setV4min:(float)min {
  _varMin[3] = min;
  if( _var[3] < min ) {
    [self setV4:min];
  }
}

@dynamic v4max;

- (float)v4max {
  return _varMax[3];
}

- (void)setV4max:(float)max {
  _varMax[3] = max;
  if( _var[3] > max ) {
    [self setV4:max];
  }
}

@dynamic v5;

- (float)v5 {
  return _var[4];
}

- (void)setV5:(float)var {
  _var[4] = var;
}

@dynamic v5min;

- (float)v5min {
  return _varMin[4];
}

- (void)setV5min:(float)min {
  _varMin[4] = min;
  if( _var[4] < min ) {
    [self setV5:min];
  }
}

@dynamic v5max;

- (float)v5max {
  return _varMax[4];
}

- (void)setV5max:(float)max {
  _varMax[4] = max;
  if( _var[4] > max ) {
    [self setV5:max];
  }
}

@dynamic v6;

- (float)v6 {
  return _var[5];
}

- (void)setV6:(float)var {
  _var[5] = var;
}

@dynamic v6min;

- (float)v6min {
  return _varMin[5];
}

- (void)setV6min:(float)min {
  _varMin[5] = min;
  if( _var[5] < min ) {
    [self setV6:min];
  }
}

@dynamic v6max;

- (float)v6max {
  return _varMax[5];
}

- (void)setV6max:(float)max {
  _varMax[5] = max;
  if( _var[5] > max ) {
    [self setV6:max];
  }
}

@dynamic v7;

- (float)v7 {
  return _var[6];
}

- (void)setV7:(float)var {
  _var[6] = var;
}

@dynamic v7min;

- (float)v7min {
  return _varMin[6];
}

- (void)setV7min:(float)min {
  _varMin[6] = min;
  if( _var[6] < min ) {
    [self setV7:min];
  }
}

@dynamic v7max;

- (float)v7max {
  return _varMax[6];
}

- (void)setV7max:(float)max {
  _varMax[6] = max;
  if( _var[6] > max ) {
    [self setV7:max];
  }
}

@dynamic v8;

- (float)v8 {
  return _var[7];
}

- (void)setV8:(float)var {
  _var[7] = var;
}

@dynamic v8min;

- (float)v8min {
  return _varMin[7];
}

- (void)setV8min:(float)min {
  _varMin[7] = min;
  if( _var[7] < min ) {
    [self setV8:min];
  }
}

@dynamic v8max;

- (float)v8max {
  return _varMax[7];
}

- (void)setV8max:(float)max {
  _varMax[7] = max;
  if( _var[7] > max ) {
    [self setV8:max];
  }
}

@dynamic timer1;

- (ELTimerCallback *)timer1 {
  return _timer[0];
}

@dynamic timer2;

- (ELTimerCallback *)timer2 {
  return _timer[1];
}

@dynamic timer3;

- (ELTimerCallback *)timer3 {
  return _timer[2];
}

@dynamic timer4;

- (ELTimerCallback *)timer4 {
  return _timer[3];
}


#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
  if( ( self = [self init] ) ) {
    BOOL hasValue;
    
    for( NSXMLNode *node in [representation nodesForXPath:@"flags/flag" error:error] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      int index = [element attributeAsInteger:@"index" hasValue:&hasValue];
      if( !hasValue ) {
        NSLog( @"Error loading script flag!" );
        return nil;
      }
      
      _flag[index] = [element attributeAsBool:@"set"];
    }
    
    for( NSXMLNode *node in [representation nodesForXPath:@"vars/var" error:error] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      int index = [element attributeAsInteger:@"index" hasValue:&hasValue];
      if( !hasValue ) {
        NSLog( @"Error loading script var!" );
        return nil;
      }
      
      _var[index] = [element attributeAsDouble:@"value" defaultValue:0.0];
      _varMin[index] = [element attributeAsDouble:@"min" defaultValue:0.0];
      _varMax[index] = [element attributeAsDouble:@"max" defaultValue:0.0];
    }
  }
  
  return self;
}

- (NSXMLElement *)xmlRepresentation {
  NSXMLElement *pkgElement = [NSXMLNode elementWithName:@"package"];
  
  NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
  
  NSXMLElement *flagsElement = [NSXMLNode elementWithName:@"flags"];
  for( int i = 0; i < 8; i++ ) {
    NSXMLElement *flagElement = [NSXMLNode elementWithName:@"flag"];
    [attributes removeAllObjects];
    [attributes setObject:[NSNumber numberWithBool:_flag[i]] forKey:@"set"];
    [attributes setObject:[NSNumber numberWithInt:i] forKey:@"index"];
    [flagElement setAttributesAsDictionary:attributes];
    [flagsElement addChild:flagElement];
  }
  [pkgElement addChild:flagsElement];
  
  NSXMLElement *varsElement = [NSXMLNode elementWithName:@"vars"];
  for( int i = 0; i < 8; i++ ) {
    NSXMLElement *varElement = [NSXMLNode elementWithName:@"var"];
    [attributes removeAllObjects];
    [attributes setObject:[NSNumber numberWithFloat:_var[i]] forKey:@"value"];
    [attributes setObject:[NSNumber numberWithFloat:_varMin[i]] forKey:@"min"];
    [attributes setObject:[NSNumber numberWithFloat:_varMax[i]] forKey:@"max"];
    [attributes setObject:[NSNumber numberWithInt:i] forKey:@"index"];
    [varElement setAttributesAsDictionary:attributes];
    [varsElement addChild:varElement];
  }
  [pkgElement addChild:varsElement];
  
  NSXMLElement *timersElement = [NSXMLNode elementWithName:@"timers"];
  for( int i = 0; i < 4; i++ ) {
    [timersElement addChild:[_timer[i] xmlRepresentation]];
  }
  [pkgElement addChild:timersElement];
  
  return pkgElement;
}

@end
