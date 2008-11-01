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
#import "ELOscillatorDesignerController.h"
#import "ELActivityViewerController.h"
#import "ELMIDIConfigController.h"

#import "ElysiumDocument.h"
#import "ELLayer.h"

NSString * const ELNotifyObjectSelectionDidChange = @"elysium.objectSelectionDidChange";
NSString * const ELNotifyCellWasUpdated = @"elysium.cellWasUpdated";

NSString * const ELNotifyPlayerShouldStart = @"elysium.playerShouldStart";
NSString * const ELNotifyPlayerShouldStop = @"elysium.playerShouldStop";

@implementation ElysiumController

+ (void)initialize {
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(173.0/255)
                                                                                        green:(195.0/255)
                                                                                         blue:(214.0/255)
                                                                                        alpha:0.8]]
                    forKey:ELDefaultCellBackgroundColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(105.0/255)
                                                                                             green:(146.0/255)
                                                                                              blue:(180.0/255)
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
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(121.0/255)
                                                                                             green:(121.0/255)
                                                                                              blue:(152.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDisabledToolColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(156.0/255)
                                                                                             green:(16.0/255)
                                                                                              blue:(45.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDefaultActivePlayheadColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(158.0/255)
                                                                                             green:(48.0/255)
                                                                                              blue:(75.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELTonicNoteColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(39.0/255)
                                                                                             green:(118.0/255)
                                                                                              blue:(131.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELScaleNoteColor];
  
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init {
  if( ( self = [super init] ) ) {
  }
  
  return self;
}

- (void)awakeFromNib {
  [ELMIDIController sharedInstance];
  [self initMacRuby];
}

- (void)initMacRuby {
  [[NSGarbageCollector defaultCollector] disable];
  MacRuby *runtime = [MacRuby sharedRuntime];
  [[NSGarbageCollector defaultCollector] enable];
  [runtime loadBridgeSupportFileAtPath:[[NSBundle mainBundle] pathForResource:@"Elysium" ofType:@"bridgesupport"]];
  [runtime evaluateString:@"framework 'Cocoa'"];
}

// Actions

- (IBAction)showOscillatorDesigner:(id)_sender_ {
  if( !oscillatorDesignerController ) {
    oscillatorDesignerController = [[ELOscillatorDesignerController alloc] initWithPlayer:[[[NSDocumentController sharedDocumentController] currentDocument] player]];
  }
  
  [oscillatorDesignerController showWindow:self];
}

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

- (IBAction)showActivityViewer:(id)_sender_ {
  if( !activityViewerController ) {
    activityViewerController = [[ELActivityViewerController alloc] init];
  }
  
  [activityViewerController showWindow:self];
}

- (IBAction)showMIDIConfigInspector:(id)_sender_ {
  if( !midiConfigController ) {
    midiConfigController = [[ELMIDIConfigController alloc] initWithPlayer:[[[NSDocumentController sharedDocumentController] currentDocument] player]];
  }
  
  [midiConfigController showWindow:self];
}

- (IBAction)satisfyMe:(id)_sender_ {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://getsatisfaction.com/lucidmac/products/lucidmac_elysium"]];
}

- (void)recordActivity:(NSDictionary *)_activity_ {
  [activityViewerController recordActivity:_activity_];
}

@end
