//
//  ELPaletteController.m
//  Elysium
//
//  Created by Matt Mower on 26/08/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "ELPaletteController.h"

@implementation ELPaletteController

- (id)init {
  if( ( self = [super initWithWindowNibName:@"Palette"] ) ) {
  }
  return self;
}

- (void)awakeFromNib {
  [palettePanel setFloatingPanel:YES];
  [palettePanel setBecomesKeyOnlyIfNeeded:YES];
}

- (void)buttonSelected:(id)_sender_ {
  NSLog( @"Ping: %@ sel.cell %@", _sender_, [_sender_ selectedCell] );
  NSLog( @"%d", [[_sender_ selectedCell] tag] );
}

@end
