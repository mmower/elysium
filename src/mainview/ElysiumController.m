//
//  ElysiumController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import "Elysium.h"

#import "ElysiumController.h"

#import "ELMIDIController.h"
#import "ELPaletteController.h"

#import "ELHexInspectorController.h"
#import "ELLayerInspectorController.h"
#import "ELPlayerInspectorController.h"

#import "ElysiumDocument.h"
#import "ELLayer.h"

extern NSString * const ELDefaultCellBackgroundColor;
extern NSString * const ELDefaultCellBorderColor;
extern NSString * const ELDefaultSelectedCellBackgroundColor;
extern NSString * const ELDefaultSelectedCellBorderColor;
extern NSString * const ELDefaultToolColor;
extern NSString * const ELDefaultActivePlayheadColor;

NSString * const ELNotifyObjectSelectionDidChange = @"elysium.objectSelectionDidChange";
NSString * const ELNotifyCellWasUpdated = @"elysium.cellWasUpdated";

@implementation ElysiumController

+ (void)initialize {
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(12.0/255)
                                                                                        green:(153.0/255)
                                                                                         blue:(206.0/255)
                                                                                        alpha:0.8]]
                    forKey:ELDefaultCellBackgroundColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(58.0/255)
                                                                                             green:(46.0/255)
                                                                                              blue:(223.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultCellBorderColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(179.0/255)
                                                                                             green:(158.0/255)
                                                                                              blue:(241.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultSelectedCellBackgroundColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(108.0/255)
                                                                                             green:(69.0/255)
                                                                                              blue:(229.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultSelectedCellBorderColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(16.0/255)
                                                                                             green:(17.0/255)
                                                                                              blue:(156.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultToolColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(156.0/255)
                                                                                             green:(16.0/255)
                                                                                              blue:(45.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultActivePlayheadColor];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init {
  if( ( self = [super init] ) ) {
    midiController = [[ELMIDIController alloc] init];
  }
  
  return self;
}

- (void)awakeFromNib {
}

- (ELMIDIController *)midiController {
  return midiController;
}

// Actions

- (IBAction)showHexInspector:(id)_sender_ {
  if( !hexInspectorController ) {
    hexInspectorController = [[ELHexInspectorController alloc] init];
  }
  
  [hexInspectorController showWindow:self];
  [hexInspectorController focus:[[[[[NSDocumentController sharedDocumentController] currentDocument] player] layer:0] selectedHex]];
}

- (IBAction)showLayerInspector:(id)_sender_ {
  if( !layerInspectorController ) {
    layerInspectorController = [[ELLayerInspectorController alloc] init];
  }
  
  [layerInspectorController showWindow:self];
  [layerInspectorController focus:[[[[NSDocumentController sharedDocumentController] currentDocument] player] layer:0]];
}

- (IBAction)showPlayerInspector:(id)_sender_ {
  if( !playerInspectorController ) {
    playerInspectorController = [[ELPlayerInspectorController alloc] init];
  }
  
  [playerInspectorController showWindow:self];
  [playerInspectorController focus:[[[NSDocumentController sharedDocumentController] currentDocument] player]];
}

- (IBAction)showInspectorPanel:(id)_sender_ {
  [self showPlayerInspector:self];
  [self showLayerInspector:self];
  [self showHexInspector:self];
}

- (IBAction)showPalette:(id)_sender_ {
  if( !paletteController ) {
    paletteController = [[ELPaletteController alloc] init];
  }
  
  // Asking inspector to show itself
  [paletteController showWindow:self];
}

@end
