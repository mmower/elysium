//
//  ELPaletteController.h
//  Elysium
//
//  Created by Matt Mower on 26/08/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELPaletteController : NSWindowController {
  IBOutlet  NSPanel     *palettePanel;
  IBOutlet  NSMatrix    *buttonMatrix;
}

- (void)buttonSelected:(id)sender;

@end
