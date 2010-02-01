//
//  ELLayerManagerWindowController.m
//  Elysium
//
//  Created by Matt Mower on 06/09/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELLayerManagerWindowController.h"

@interface ELLayerManagerWindowController (PrivateMethods)

- (void)documentsClosed:(NSNotification *)notification;

@end


@implementation ELLayerManagerWindowController

- (id)init {
  if( ( self = [self initWithWindowNibName:@"LayerManager"] ) ) {
    // Custom initialization here
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



// - (void)windowDidLoad {
//   [[self window] setTitle:[NSString stringWithFormat:@"%@ - Layer Manager", [[self document] displayName]]];
// }


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
  int row = [[notification object] selectedRow];
  if( row == -1 ) {
    return;
  }
}


- (void)documentsClosed:(NSNotification *)notification {
  [[self window] orderOut:self];
}


// - (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
//   return [NSString stringWithFormat:@"%@ - Layer Manager", displayName];
// }

@end
