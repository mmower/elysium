//
//  ELInspectorPane.m
//  Elysium
//
//  Created by Matt Mower on 10/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//
//  Based on AIModularPane.m from the Adium source code
//

#import "ELInspectorPane.h"

@implementation ELInspectorPane

@dynamic paneView;
@synthesize label;
@synthesize nibName;
@synthesize inspectee;

- (id)init {
  NSAssert( NO, @"The default constructor for ELInspectorPane should not be called. Use initWithLabel:nibName: instead!" );
  return nil;
}

- (id)initWithLabel:(NSString *)_label_ nibName:(NSString *)_nibName_ {
  if( self = [super init] ) {
    label    = _label_;
    nibName  = _nibName_;
    paneView = nil;
  }
  
  return self;
}

- (NSView *)paneView {
  if( !paneView ) {
    NSLog( @"Loading nib: %@", [self nibName] );
    [NSBundle loadNibNamed:[self nibName] owner:self];
    [self viewDidLoad];
  }
  
  [paneView setAutoresizingMask:NSViewMaxYMargin];
  
  return paneView;
}


- (void)closeView {
  if( paneView ) {
    [self viewWillClose];
    paneView = nil;
  }
}

- (void)viewDidLoad {
}

- (void)viewWillClose {
}

- (BOOL)willInspect:(Class)class {
  return NO;
}

// Override this method to focus on some part of the inspected object
- (id)focus:(id)_inspectee_ {
  return _inspectee_;
}

- (void)inspect:(id)_inspectee_ {
  NSLog( @"Inspector %@ inspecting %@", self, _inspectee_ );
  [self willChangeValueForKey:@"inspectee"];
  inspectee = [self focus:_inspectee_];
  [self didChangeValueForKey:@"inspectee"];
}

@end
