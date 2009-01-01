//
//  ELKey.m
//  Elysium
//
//  Created by Matt Mower on 15/10/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELKey.h"

#import "ELNote.h"

static NSMutableArray *allKeys = nil;
static NSMutableDictionary *keyLookup = nil;

@implementation ELKey

+ (void)initialize {
  if( allKeys == nil ) {
    allKeys = [[NSMutableArray alloc] init];
    
    [allKeys addObject:[[ELKey alloc] initWithName:@"None" scale:[NSArray array]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"A major" scale:[NSArray arrayWithObjects:@"A",@"B",@"C#",@"D",@"E",@"F#",@"G#",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"A minor" scale:[NSArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",@"G",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"A flat major" scale:[NSArray arrayWithObjects:@"Ab",@"Bb",@"C",@"Db",@"Eb",@"F",@"G",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"A flat minor" scale:[NSArray arrayWithObjects:@"Ab",@"Bb",@"B",@"Db",@"Eb",@"E",@"Gb",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"A sharp minor" scale:[NSArray arrayWithObjects:@"A#",@"C",@"C#",@"D#",@"F",@"F#",@"G#",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"B major" scale:[NSArray arrayWithObjects:@"B",@"C#",@"D#",@"E",@"F#",@"G#",@"A#",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"B minor" scale:[NSArray arrayWithObjects:@"B",@"C#",@"D",@"E",@"F#",@"G",@"A",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"B flat major" scale:[NSArray arrayWithObjects:@"Bb",@"C",@"D",@"Eb",@"F",@"G",@"A",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"B flat minor" scale:[NSArray arrayWithObjects:@"Bb",@"C",@"Db",@"Eb",@"F",@"Gb",@"Ab",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"C major" scale:[NSArray arrayWithObjects:@"C",@"D",@"E",@"F",@"G",@"A",@"B",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"C minor" scale:[NSArray arrayWithObjects:@"C",@"D",@"Eb",@"F",@"G",@"Ab",@"Bb",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"C flat major" scale:[NSArray arrayWithObjects:@"B",@"Db",@"Eb",@"E",@"Gb",@"Ab",@"Bb",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"C sharp major" scale:[NSArray arrayWithObjects:@"C#",@"D#",@"F",@"F#",@"G#",@"A#",@"C",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"C sharp minor" scale:[NSArray arrayWithObjects:@"C#",@"D#",@"E",@"F#",@"G#",@"A",@"B",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"D major" scale:[NSArray arrayWithObjects:@"D",@"E",@"F#",@"G",@"A",@"B",@"C#",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"D minor" scale:[NSArray arrayWithObjects:@"D",@"E",@"F",@"G",@"A",@"Bb",@"C",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"D flat major" scale:[NSArray arrayWithObjects:@"Db",@"Eb",@"F",@"Gb",@"Ab",@"Bb",@"C",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"D flat minor" scale:[NSArray arrayWithObjects:@"Db",@"Eb",@"E",@"Gb",@"Ab",@"Bb",@"B",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"D sharp minor" scale:[NSArray arrayWithObjects:@"D#",@"F",@"F#",@"G#",@"A#",@"B",@"C#",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"E major" scale:[NSArray arrayWithObjects:@"E",@"F#",@"G#",@"A",@"B",@"C#",@"D#",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"E minor" scale:[NSArray arrayWithObjects:@"E",@"F#",@"G",@"A",@"B",@"C",@"D",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"E flat major" scale:[NSArray arrayWithObjects:@"Eb",@"F",@"G",@"Ab",@"B",@"C",@"D",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"E flat minor" scale:[NSArray arrayWithObjects:@"Eb",@"F",@"Gb",@"Ab",@"Bb",@"B",@"Db",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"F major" scale:[NSArray arrayWithObjects:@"F",@"G",@"A",@"Bb",@"C",@"D",@"E",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"F minor" scale:[NSArray arrayWithObjects:@"F",@"G",@"Ab",@"Bb",@"C",@"Db",@"Eb",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"F flat major" scale:[NSArray arrayWithObjects:@"E",@"Gb",@"Ab",@"A",@"B",@"Db",@"Eb",@"E",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"F sharp major" scale:[NSArray arrayWithObjects:@"F#",@"G#",@"A#",@"B",@"C#",@"D#",@"F",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"F sharp minor" scale:[NSArray arrayWithObjects:@"F#",@"G#",@"A",@"B",@"C#",@"D",@"E",nil]]];

    [allKeys addObject:[[ELKey alloc] initWithName:@"G major" scale:[NSArray arrayWithObjects:@"G",@"A",@"B",@"C",@"D",@"E",@"F#",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"G minor" scale:[NSArray arrayWithObjects:@"G",@"A",@"Bb",@"C",@"D",@"Eb",@"F",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"G flat minor" scale:[NSArray arrayWithObjects:@"Gb",@"Ab",@"Bb",@"B",@"Db",@"Eb",@"F",nil]]];
    [allKeys addObject:[[ELKey alloc] initWithName:@"G sharp minor" scale:[NSArray arrayWithObjects:@"G#",@"A#",@"B",@"C#",@"D#",@"E",@"F#",nil]]];
    
    keyLookup = [NSMutableDictionary dictionary];
    for( ELKey *key in allKeys ) {
      [keyLookup setObject:key forKey:[key name]];
    }
  }
}

+ (NSArray *)allKeys {
  return allKeys;
}

+ (ELKey *)keyNamed:(NSString *)_name_ {
  return [keyLookup objectForKey:_name_];
}

+ (ELKey *)noKey {
  return [allKeys objectAtIndex:0];
}

- (id)initWithName:(NSString *)_name_ scale:(NSArray *)_scale_ {
  if( ( self = [super init] ) ) {
    name  = _name_;
    scale = _scale_;
    
    flat = NO;
    for( NSString *note in scale ) {
      if( [[note substringFromIndex:[note length]-1] isEqualToString:@"b"] ) {
        flat = YES;
        break;
      }
    }
  }
  
  return self;
}

@synthesize name;
@synthesize scale;
@synthesize flat;

- (NSString *)description {
  return name;
}

- (BOOL)containsNote:(ELNote *)_note_ isTonic:(BOOL *)_isTonic_ {
  NSUInteger index = [scale indexOfObject:[_note_ tone:flat]];
  if( index == NSNotFound ) {
    return NO;
  }
  
  if( index == 0 ) {
    *(_isTonic_) = YES;
  } else {
    *(_isTonic_) = NO;
  }
  
  return YES;
}

@end
