//
//  ELBooleanKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELBooleanKnob.h"

@implementation ELBooleanKnob

- (id)initWithName:(NSString*)_name_
      booleanValue:(BOOL)_value_
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
  if( ( self = [self initWithName:name
                       linkedKnob:_knob_
                          enabled:_enabled_
                       hasEnabled:_hasEnabled_
                      linkEnabled:_linkEnabled_
                         hasValue:_hasValue_
                        linkValue:_linkValue_
                            alpha:_alpha_
                         hasAlpha:_hasAlpha_
                        linkAlpha:_linkAlpha_
                                p:_p_
                             hasP:_hasP_
                            linkP:_linkP_
                           filter:_filter_
                       linkFilter:_linkFilter_
                        predicate:_predicate_
                    linkPredicate:_linkPredicate_] ) )
  {
    value = _value_;
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ booleanValue:(BOOL)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (NSString *)xmlType {
  return @"boolean";
}

- (BOOL)value {
  NSAssert( hasValue || linkValue, @"Value must be either defined or linked!" );
  
  if( hasValue ) {
    return value;
  } else if( linkValue ) {
    return [(ELBooleanKnob *)linkedKnob value];
  } else {
    NSLog( @"value called on ELBooleanKnob with no value or linkage." );
    abort();
  }
}

- (NSString *)stringValue {
  return [self value] ? @"YES" : @"NO";
}

- (void)setValue:(BOOL)_value_ {
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                              booleanValue:value
                                                linkedKnob:linkedKnob
                                                   enabled:enabled
                                                hasEnabled:hasEnabled
                                               linkEnabled:linkEnabled
                                                  hasValue:hasValue
                                                 linkValue:linkValue
                                                     alpha:alpha
                                                  hasAlpha:hasAlpha
                                                 linkAlpha:linkAlpha
                                                         p:p
                                                      hasP:hasP
                                                     linkP:linkP
                                                    filter:filter
                                                linkFilter:linkFilter
                                                 predicate:predicate
                                             linkPredicate:linkPredicate];
}

@end
