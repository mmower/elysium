//
//  ELFloatKnob.m
//  Elysium
//
//  Created by Matt Mower on 13/09/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELFloatKnob.h"

#import "ELFilter.h"

@implementation ELFloatKnob

- (id)initWithName:(NSString*)_name_
        floatValue:(float)_value_
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
            filter:(ELFilter*)_filter_
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

- (id)initWithName:(NSString *)_name_ floatValue:(float)_value_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setValue:_value_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ linkedTo:(ELKnob *)_knob_ {
  if( ( self = [self initWithName:_name_] ) ) {
    [self setLinkedKnob:_knob_];
    [self setLinkValue:YES];
  }
  
  return self;
}

- (NSString *)xmlType {
  return @"float";
}

- (float)value {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob value];
  } else if( hasValue ) {
    return value;
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELFloatKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (float)filteredValue {
  if( linkValue ) {
    return [(ELFloatKnob *)linkedKnob filteredValue];
  } else if( hasValue ) {
    return [self filteredValue:value];
  } else {
    @throw [NSException exceptionWithName:@"KnobException" reason:@"Value called on ELFloatKnob with no value or linkage." userInfo:[NSDictionary dictionaryWithObject:self forKey:@"knob"]];
  }
}

- (float)filteredValue:(float)_value_ {
  if( filter && [filter enabled] ) {
    return [filter generate];
  } else {
    return _value_;
  }
}

- (NSString *)stringValue {
  return [[NSNumber numberWithFloat:[self value]] stringValue];
}

- (void)setValueWithString:(NSString *)_stringValue_ {
  [self setValue:[_stringValue_ floatValue]];
}

- (void)setValue:(float)_value_ {
  hasValue = YES;
  value    = _value_;
}

- (void)clearValue {
  hasValue = NO;
}

// NSMutableCopying protocol

- (id)mutableCopyWithZone:(NSZone *)_zone_ {
  return [[[self class] allocWithZone:_zone_] initWithName:name
                                                floatValue:value
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
