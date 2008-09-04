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
  NSLog( @"[%@ paneView]", [self className] );
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

- (Class)willInspect {
  return nil;
}

- (void)inspect:(id)_inspectee_ {
  NSLog( @"Inspector %@ inspecting %@", self, _inspectee_ );
  
  if( _inspectee_ != inspectee ) {
    [self willChangeValueForKey:@"inspectee"];
    if( _inspectee_ ) {
      inspectee = [self narrowInspectionFocus:_inspectee_];
      [self showIfNecessary];
    } else {
      inspectee = nil;
      [self hideIfNecessary];
    }
    [self didChangeValueForKey:@"inspectee"];
  }
}

- (id)narrowInspectionFocus:(id)_object_ {
  return _object_;
}

- (void)hideIfNecessary {
  
}

- (void)showIfNecessary {
  
}

@end
