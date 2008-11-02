//
//  ELScriptPackage.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELScriptPackage.h"

#import "ELPlayer.h"
#import "ELTimerCallback.h"

@implementation ELScriptPackage

- (id)initWithPlayer:(ELPlayer *)_player_ {
  if( ( self = [super init] ) ) {
    player = _player_;
    
    for( int i = 0; i < 8; i++ ) {
      flag[i] = NO;
      var[i] = 0.0;
      varMin[i] = 0.0;
      varMax[i] = 127.0;
    }
    
    for( int i = 0; i < 4; i++ ) {
      timer[i] = [[ELTimerCallback alloc] initWithPlayer:player];
    }
  }
  
  NSLog( @"Timer 1 interval = %f", [timer[0] interval] );
  
  return self;
}

@synthesize player;

@dynamic f1;

- (BOOL)f1 {
  return flag[0];
}

- (void)setF1:(BOOL)_set_ {
  flag[0] = _set_;
}

@dynamic f2;

- (BOOL)f2 {
  return flag[1];
}

- (void)setF2:(BOOL)_set_ {
  flag[1] = _set_;
}

@dynamic f3;

- (BOOL)f3 {
  return flag[2];
}

- (void)setF3:(BOOL)_set_ {
  flag[2] = _set_;
}

@dynamic f4;

- (BOOL)f4 {
  return flag[3];
}

- (void)setF4:(BOOL)_set_ {
  flag[3] = _set_;
}

@dynamic f5;

- (BOOL)f5 {
  return flag[4];
}

- (void)setF5:(BOOL)_set_ {
  flag[4] = _set_;
}

@dynamic f6;

- (BOOL)f6 {
  return flag[5];
}

- (void)setF6:(BOOL)_set_ {
  flag[5] = _set_;
}

@dynamic f7;

- (BOOL)f7 {
  return flag[6];
}

- (void)setF7:(BOOL)_set_ {
  flag[6] = _set_;
}

@dynamic f8;

- (BOOL)f8 {
  return flag[7];
}

- (void)setF8:(BOOL)_set_ {
  flag[7] = _set_;
}

@dynamic v1;

- (float)v1 {
  return var[0];
}

- (void)setV1:(float)_var_ {
  var[0] = _var_;
}

@dynamic v1min;

- (float)v1min {
  return varMin[0];
}

- (void)setV1min:(float)_min_ {
  varMin[0] = _min_;
  if( var[0] < _min_ ) {
    [self setV1:_min_];
  }
}

@dynamic v1max;

- (float)v1max {
  return varMax[0];
}

- (void)setV1max:(float)_max_ {
  varMax[0] = _max_;
  if( var[0] > _max_ ) {
    [self setV1:_max_];
  }
}

@dynamic v2;

- (float)v2 {
  return var[1];
}

- (void)setV2:(float)_var_ {
  var[1] = _var_;
}

@dynamic v2min;

- (float)v2min {
  return varMin[1];
}

- (void)setV2min:(float)_min_ {
  varMin[1] = _min_;
  if( var[1] < _min_ ) {
    [self setV2:_min_];
  }
}

@dynamic v2max;

- (float)v2max {
  return varMax[1];
}

- (void)setV2max:(float)_max_ {
  varMax[1] = _max_;
  if( var[1] > _max_ ) {
    [self setV2:_max_];
  }
}

@dynamic v3;

- (float)v3 {
  return var[2];
}

- (void)setV3:(float)_var_ {
  var[2] = _var_;
}

@dynamic v3min;

- (float)v3min {
  return varMin[2];
}

- (void)setV3min:(float)_min_ {
  varMin[2] = _min_;
  if( var[2] < _min_ ) {
    [self setV3:_min_];
  }
}

@dynamic v3max;

- (float)v3max {
  return varMax[2];
}

- (void)setV3max:(float)_max_ {
  varMax[2] = _max_;
  if( var[2] > _max_ ) {
    [self setV3:_max_];
  }
}

@dynamic v4;

- (float)v4 {
  return var[3];
}

- (void)setV4:(float)_var_ {
  var[3] = _var_;
}

@dynamic v4min;

- (float)v4min {
  return varMin[3];
}

- (void)setV4min:(float)_min_ {
  varMin[3] = _min_;
  if( var[3] < _min_ ) {
    [self setV4:_min_];
  }
}

@dynamic v4max;

- (float)v4max {
  return varMax[3];
}

- (void)setV4max:(float)_max_ {
  varMax[3] = _max_;
  if( var[3] > _max_ ) {
    [self setV4:_max_];
  }
}

@dynamic v5;

- (float)v5 {
  return var[4];
}

- (void)setV5:(float)_var_ {
  var[4] = _var_;
}

@dynamic v5min;

- (float)v5min {
  return varMin[4];
}

- (void)setV5min:(float)_min_ {
  varMin[4] = _min_;
  if( var[4] < _min_ ) {
    [self setV5:_min_];
  }
}

@dynamic v5max;

- (float)v5max {
  return varMax[4];
}

- (void)setV5max:(float)_max_ {
  varMax[4] = _max_;
  if( var[4] > _max_ ) {
    [self setV5:_max_];
  }
}

@dynamic v6;

- (float)v6 {
  return var[5];
}

- (void)setV6:(float)_var_ {
  var[5] = _var_;
}

@dynamic v6min;

- (float)v6min {
  return varMin[5];
}

- (void)setV6min:(float)_min_ {
  varMin[5] = _min_;
  if( var[5] < _min_ ) {
    [self setV6:_min_];
  }
}

@dynamic v6max;

- (float)v6max {
  return varMax[5];
}

- (void)setV6max:(float)_max_ {
  varMax[5] = _max_;
  if( var[5] > _max_ ) {
    [self setV6:_max_];
  }
}

@dynamic v7;

- (float)v7 {
  return var[6];
}

- (void)setV7:(float)_var_ {
  var[6] = _var_;
}

@dynamic v7min;

- (float)v7min {
  return varMin[6];
}

- (void)setV7min:(float)_min_ {
  varMin[6] = _min_;
  if( var[6] < _min_ ) {
    [self setV7:_min_];
  }
}

@dynamic v7max;

- (float)v7max {
  return varMax[6];
}

- (void)setV7max:(float)_max_ {
  varMax[6] = _max_;
  if( var[6] > _max_ ) {
    [self setV7:_max_];
  }
}

@dynamic v8;

- (float)v8 {
  return var[7];
}

- (void)setV8:(float)_var_ {
  var[7] = _var_;
}

@dynamic v8min;

- (float)v8min {
  return varMin[7];
}

- (void)setV8min:(float)_min_ {
  varMin[7] = _min_;
  if( var[7] < _min_ ) {
    [self setV8:_min_];
  }
}

@dynamic v8max;

- (float)v8max {
  return varMax[7];
}

- (void)setV8max:(float)_max_ {
  varMax[7] = _max_;
  if( var[7] > _max_ ) {
    [self setV8:_max_];
  }
}

@dynamic timer1;

- (ELTimerCallback *)timer1 {
  return timer[0];
}

@dynamic timer2;

- (ELTimerCallback *)timer2 {
  return timer[1];
}

@dynamic timer3;

- (ELTimerCallback *)timer3 {
  return timer[2];
}

@dynamic timer4;

- (ELTimerCallback *)timer4 {
  return timer[3];
}

// ELXmlData protocol implementation

- (id)initWithXmlRepresentation:(NSXMLElement *)_representation_ parent:(id)_parent_ player:(ELPlayer *)_player_ {
  if( ( self = [self init] ) ) {
    for( NSXMLNode *node in [_representation_ nodesForXPath:@"flags/flag" error:nil] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      int index = [[[element attributeForName:@"index"] stringValue] intValue];
      BOOL set = [[[element attributeForName:@"set"] stringValue] boolValue];
      
      flag[index] = set;
    }
    
    for( NSXMLNode *node in [_representation_ nodesForXPath:@"vars/var" error:nil] ) {
      NSXMLElement *element = (NSXMLElement *)node;
      
      int index = [[[element attributeForName:@"index"] stringValue] intValue];
      float value = [[[element attributeForName:@"value"] stringValue] floatValue];
      float min = [[[element attributeForName:@"min"] stringValue] floatValue];
      float max = [[[element attributeForName:@"max"] stringValue] floatValue];
      
      var[index] = value;
      varMin[index] = min;
      varMax[index] = max;
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
    [attributes setObject:[NSNumber numberWithBool:flag[i]] forKey:@"set"];
    [attributes setObject:[NSNumber numberWithInt:i] forKey:@"index"];
    [flagElement setAttributesAsDictionary:attributes];
    [flagsElement addChild:flagElement];
  }
  [pkgElement addChild:flagsElement];
  
  NSXMLElement *varsElement = [NSXMLNode elementWithName:@"vars"];
  for( int i = 0; i < 8; i++ ) {
    NSXMLElement *varElement = [NSXMLNode elementWithName:@"var"];
    [attributes removeAllObjects];
    [attributes setObject:[NSNumber numberWithFloat:var[i]] forKey:@"value"];
    [attributes setObject:[NSNumber numberWithFloat:varMin[i]] forKey:@"min"];
    [attributes setObject:[NSNumber numberWithFloat:varMax[i]] forKey:@"max"];
    [attributes setObject:[NSNumber numberWithInt:i] forKey:@"index"];
    [varElement setAttributesAsDictionary:attributes];
    [varsElement addChild:varElement];
  }
  [pkgElement addChild:varsElement];
  
  NSXMLElement *timersElement = [NSXMLNode elementWithName:@"timers"];
  for( int i = 0; i < 4; i++ ) {
    [timersElement addChild:[timer[i] xmlRepresentation]];
  }
  [pkgElement addChild:timersElement];
  
  return pkgElement;
}

@end
