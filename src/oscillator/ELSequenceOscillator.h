//
//  ELSequenceOscillator.h
//  Elysium
//
//  Created by Matt Mower on 21/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import <Cocoa/Cocoa.h>

#import "ELOscillator.h"

@interface ELSequenceValue : NSObject {
  int       _intValue;
  NSString  *_stringValue;
}

- (id)initWithStringValue:(NSString *)stringValue;

@property int intValue;
@property (assign) NSString *stringValue;

@end

@interface ELSequenceOscillator : ELOscillator {
  NSMutableArray  *_values;
  int             _index;
}

- (id)initEnabled:(BOOL)enabled values:(NSArray *)values;

@property (assign) NSMutableArray *values;

// - (void)setEditable:(BOOL)editable;
// - (NSMutableArray *)editableValues;
// - (NSMutableArray *)usableValues;

@end
