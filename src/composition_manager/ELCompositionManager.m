//
//  ELCompositionManager.m
//  Elysium
//
//  Created by Matt Mower on 10/03/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ELCompositionManager.h"


@interface ELCompositionManager (PrivateMethods)

- (void)documentsClosed:(NSNotification *)notification;

@end


@implementation ELCompositionManager

- (id)init {
  if( ( self = [super initWithWindowNibName:@"CompositionManager"] ) ) {
    [self setShouldCloseDocument:NO];
  }
  
  return self;
}


#pragma mark NSNibAwakening protocol

- (void)awakeFromNib {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(documentsClosed:)
                                               name:ELNotifyAllDocumentsClosed
                                             object:nil];
}


- (void)documentsClosed:(NSNotification *)notification {
  [[self window] orderOut:self];
}


@end
