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

NSString* const ELNotifyCellWasUpdated = @"elysium.cellWasUpdated";

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

- (void)inspect:(id)_inspectee_ {
  NSLog( @"Inspector %@ inspecting %@", self, _inspectee_ );
  [self willChangeValueForKey:@"inspectee"];
  inspectee = _inspectee_;
  [self didChangeValueForKey:@"inspectee"];
  [self updateBindings];
}

// If you have custom bindings not linked to inspectee, here's where to change 'em
- (void)updateBindings {
}

@end
