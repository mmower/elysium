//
//  ELCompositionManager.m
//  Elysium
//
//  Created by Matt Mower on 10/03/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELCompositionManager.h"

@implementation ELCompositionManager

- (id)init {
  if( ( self = [super initWithWindowNibName:@"CompositionManager"] ) ) {
    [self setShouldCloseDocument:NO];
  }
  
  return self;
}

@end
