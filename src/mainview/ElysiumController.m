//
//  ElysiumController.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

#import "Elysium.h"

#import "ElysiumController.h"

#import "ELMIDIController.h"

#import "ELHexInspectorController.h"
#import "ELLayerInspectorController.h"
#import "ELPlayerInspectorController.h"
#import "ELOscillatorDesignerController.h"
#import "ELMIDIConfigController.h"
#import "ELScriptPackageController.h"
#import "ELPreferencesController.h"

#import "ElysiumDocument.h"
#import "ELLayer.h"

NSString * const ELErrorDomain = @"com.lucidmac.Elysium.ErrorDomain";

NSString * const ELNotifyObjectSelectionDidChange = @"elysium.objectSelectionDidChange";
NSString * const ELNotifyCellWasUpdated = @"elysium.cellWasUpdated";

NSString * const ELNotifyPlayerShouldStart = @"elysium.playerShouldStart";
NSString * const ELNotifyPlayerShouldStop = @"elysium.playerShouldStop";

@implementation ElysiumController

+ (void)initialize {
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  
  [defaultValues setObject:[NSNumber numberWithInt:2] forKey:ELBehaviourAtOpenKey];
  [defaultValues setObject:[NSNumber numberWithFloat:0.5] forKey:ELLayerThreadPriorityKey];
  
  [defaultValues setObject:[NSNumber numberWithInt:120] forKey:ELDefaultTempoKey];
  [defaultValues setObject:[NSNumber numberWithInt:16] forKey:ELDefaultTTLKey];
  [defaultValues setObject:[NSNumber numberWithInt:16] forKey:ELDefaultPulseCountKey];
  [defaultValues setObject:[NSNumber numberWithInt:90] forKey:ELDefaultVelocityKey];
  [defaultValues setObject:[NSNumber numberWithInt:120] forKey:ELDefaultEmphasisKey];
  [defaultValues setObject:[NSNumber numberWithInt:500] forKey:ELDefaultDurationKey];
  
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
  srandomdev();
  
  if( ( self = [super init] ) ) {
  }
  
  return self;
}

- (void)awakeFromNib {
  [ELMIDIController sharedInstance];
  if( ![self initScriptingEngine] ) {
    NSLog( @"Initialization of script engine failed." );
  }
}

// NSApp delegate methods

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)_sender_ {
  return [[NSUserDefaults standardUserDefaults] integerForKey:ELBehaviourAtOpenKey] == EL_OPEN_EMPTY;
}

- (void)applicationDidFinishLaunching:(NSNotification *)_notification_ {
  if( [[NSUserDefaults standardUserDefaults] integerForKey:ELBehaviourAtOpenKey] == EL_OPEN_LAST ) {
    NSArray *recentDocuments = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    if( [recentDocuments count] > 0 ) {
      [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[recentDocuments objectAtIndex:0] display:YES];
    }
  }
}

// General initialization

- (BOOL)initScriptingEngine {
  [[BridgeSupportController sharedController] loadBridgeSupport:[[NSBundle mainBundle] pathForResource:@"Elysium" ofType:@"bridgesupport"]];
  
  NSArray *searchPathes = NSSearchPathForDirectoriesInDomains( NSApplicationSupportDirectory, NSUserDomainMask, YES );
  NSString *appSupportPath = [searchPathes objectAtIndex:0];
  NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
  NSString *elysiumAppSupportPath = [appSupportPath stringByAppendingPathComponent:appName];
  
  if( ![[NSFileManager defaultManager] fileExistsAtPath:elysiumAppSupportPath] ) {
    [[NSFileManager defaultManager] createDirectoryAtPath:elysiumAppSupportPath attributes:nil];
    NSLog( @"Created Elysium app support path" );
  }
  
  NSString *userLibPath = [elysiumAppSupportPath stringByAppendingPathComponent:@"userlib.js"];
  if( ![[NSFileManager defaultManager] fileExistsAtPath:userLibPath] ) {
    [@"// Elysium user library" writeToFile:userLibPath atomically:NO encoding:NSASCIIStringEncoding error:nil];
    NSLog( @"Written new user library" );
  } else {
    NSLog( @"Using existing user library: %@", userLibPath );
  }
  
  [[JSCocoa sharedController] evalJSFile:userLibPath];
  
  return YES;
}

- (ELPlayer *)activePlayer {
  return [[[NSDocumentController sharedDocumentController] currentDocument] player];
}

// Actions

- (IBAction)showOscillatorDesigner:(id)_sender_ {
  if( !oscillatorDesignerController ) {
    oscillatorDesignerController = [[ELOscillatorDesignerController alloc] initWithPlayer:[self activePlayer]];
  }
  
  [oscillatorDesignerController showWindow:self];
}

- (IBAction)showHexInspector:(id)_sender_ {
  if( !hexInspectorController ) {
    hexInspectorController = [[ELHexInspectorController alloc] init];
  }
  
  [hexInspectorController showWindow:self];
  [hexInspectorController focus:[[[self activePlayer] layer:0] selectedHex]];
}

- (IBAction)showLayerInspector:(id)_sender_ {
  if( !layerInspectorController ) {
    layerInspectorController = [[ELLayerInspectorController alloc] init];
  }
  
  [layerInspectorController showWindow:self];
  [layerInspectorController focus:[[self activePlayer] layer:0]];
}

- (IBAction)showPlayerInspector:(id)_sender_ {
  if( !playerInspectorController ) {
    playerInspectorController = [[ELPlayerInspectorController alloc] init];
  }
  
  [playerInspectorController showWindow:self];
  [playerInspectorController focus:[self activePlayer]];
}

- (IBAction)showInspectorPanel:(id)_sender_ {
  [self showPlayerInspector:self];
  [self showLayerInspector:self];
  [self showHexInspector:self];
}

- (IBAction)showMIDIConfigInspector:(id)_sender_ {
  if( !midiConfigController ) {
    midiConfigController = [[ELMIDIConfigController alloc] initWithPlayer:[self activePlayer]];
  }
  
  [midiConfigController showWindow:self];
}

- (IBAction)showScriptPackageInspector:(id)_sender_ {
  if( !scriptPackageController ) {
    scriptPackageController = [[ELScriptPackageController alloc] initWithPlayer:[self activePlayer]];
  }
  
  [scriptPackageController showWindow:self];
}

- (IBAction)satisfyMe:(id)_sender_ {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://getsatisfaction.com/lucidmac/products/lucidmac_elysium"]];
}

- (IBAction)showPreferences:(id)_sender_ {
  if( !preferencesController ) {
    preferencesController = [[ELPreferencesController alloc] init];
  }
  
  [preferencesController showWindow:self];
}

- (IBAction)showHelp:(id)_sender_ {
  NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"output"];
  NSLog( @"path = %@", helpPath );
  NSString *helpURL = [NSString stringWithFormat:@"file://%@", helpPath];
  NSLog( @"url = %@", helpURL );
  
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:helpURL]];
}

@end
