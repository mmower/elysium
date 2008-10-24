//
//  ELRangedKnob.m
//  Elysium
//
//  Created by Matt Mower on 23/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "ELRangedKnob.h"

@implementation ELRangedKnob

- (id)initWithName:(NSString *)_name_
           minimum:(float)_minimum_
           maximum:(float)_maximum_
          stepping:(float)_stepping_
        linkedKnob:(ELKnob *)_linkedKnob_
           enabled:(BOOL)_enabled_
        hasEnabled:(BOOL)_hasEnabled_
       linkEnabled:(BOOL)_linkEnabled_
          hasValue:(BOOL)_hasValue_
         linkValue:(BOOL)_linkValue_
            filter:(ELOscillator *)_filter_
        linkFilter:(BOOL)_linkFilter_
{
  if( ( self = [super initWithName:_name_
                        linkedKnob:_linkedKnob_
                           enabled:_enabled_
                        hasEnabled:_hasEnabled_
                       linkEnabled:_linkEnabled_
                          hasValue:_hasValue_
                         linkValue:_linkValue_
                            filter:_filter_
                        linkFilter:_linkFilter_] ) )
  {
    [self setMinimum:_minimum_];
    [self setMaximum:_maximum_];
    [self setStepping:_stepping_];
  }
  
  return self;
}

- (id)initWithName:(NSString *)_name_ minimum:(float)_minimum_ maximum:(float)_maximum_ stepping:(float)_stepping_ {
  if( ( self = [super initWithName:_name_] ) ) {
    [self setMinimum:_minimum_];
    [self setMaximum:_maximum_];
    [self setStepping:_stepping_];
  }
  
  return self;
}

@synthesize minimum;
@synthesize maximum;
@synthesize stepping;

@end
