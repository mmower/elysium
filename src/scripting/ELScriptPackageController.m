//
//  ELScriptPackageController.m
//  Elysium
//
//  Created by Matt Mower on 02/11/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ELScriptPackageController.h"

#import "ELPlayer.h"
#import "ELLayer.h"
#import "ELCell.h"

@interface ELScriptPackageController (PrivateMethods)

- (void)documentsClosed:(NSNotification *)notification;

@end


@implementation ELScriptPackageController

- (id)init {
  return [super initWithWindowNibName:@"ScriptPackageInspector"];
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
