//
//  ELSquareOscillator.m
//  Elysium
//
//  Created by Matt Mower on 20/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELSquareOscillator.h"

#import "ELOscillator.h"

@implementation ELSquareOscillator

#pragma mark Object initialization

@synthesize sustain = _sustain;
@synthesize rest = _rest;

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum hardMinimum:(int)hardMinimum maximum:(int)maximum hardMaximum:(int)hardMaximum rest:(int)rest sustain:(int)sustain {
    if ((self = [super initEnabled:enabled minimum:minimum hardMinimum:hardMinimum maximum:maximum hardMaximum:hardMaximum])) {
        [self setRest:rest];
        [self setSustain:_sustain];
    }
    
    return self;
}

- (id)initEnabled:(BOOL)enabled minimum:(int)minimum maximum:(int)maximum rest:(int)_rest_ sustain:(int)_sustain_ {
    return [self initEnabled:enabled minimum:minimum hardMinimum:minimum maximum:maximum hardMaximum:maximum rest:_rest_ sustain:_sustain_];
}

#pragma mark Properties


- (void)setRest:(int)rest {
    _rest = rest;
    [self updatePeriod];
}

- (void)setSustain:(int)sustain {
    _sustain = sustain;
    [self updatePeriod];
}

#pragma mark Object behaviours

- (NSString *)type {
    return @"Square";
}

- (void)updatePeriod {
    _period = [self rest] + [self sustain];
}

- (int)generate {
    // Get time in milliseconds
    UInt64 time = AudioConvertHostTimeToNanos(AudioGetCurrentHostTime() - [self timeBase]) / 1000000;
    int t = time % _period;
    return [self generateWithT:t];
}

- (int)generateWithT:(int)t {
    if (t < [self sustain]) {
        return [self minimum];
    }
    else {
        return [self maximum];
    }
}

#pragma mark Implements ELXmlData

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
    if ((self = [super initWithXmlRepresentation:representation parent:parent player:player error:error])) {
        NSXMLNode *attributeNode;
        
        attributeNode = [representation attributeForName:@"rest"];
        if (!attributeNode) {
            NSLog(@"No or invalid 'rest' attribute node for oscillator!");
            return nil;
        }
        else {
            [self setRest:[[attributeNode stringValue] intValue]];
        }
        
        attributeNode = [representation attributeForName:@"sustain"];
        if (!attributeNode) {
            NSLog(@"No or invalid 'sustain' attribute node for oscillator");
            return nil;
        }
        else {
            [self setSustain:[[attributeNode stringValue] intValue]];
        }
    }
    
    return self;
}

- (void)storeAttributes:(NSMutableDictionary *)attributes {
    [super storeAttributes:attributes];
    
    [attributes setObject:[NSNumber numberWithFloat:[self rest]] forKey:@"rest"];
    [attributes setObject:[NSNumber numberWithFloat:[self sustain]] forKey:@"sustain"];
}

#pragma mark Implements NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [[[self class] allocWithZone:zone] initEnabled:[self enabled]
                                                  minimum:[self minimum]
                                              hardMinimum:[self hardMinimum]
                                                  maximum:[self maximum]
                                              hardMaximum:[self hardMaximum]
                                                     rest:[self rest]
                                                  sustain:[self sustain]];
}

@end
