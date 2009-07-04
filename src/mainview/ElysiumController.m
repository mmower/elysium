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
#import "ELMIDIConfigController.h"
#import "ELPreferencesController.h"

#import "ElysiumDocument.h"
#import "ELLayer.h"

#import "ELCompositionManager.h"
#import "ELInspectorController.h"
#import "ELScriptPackageController.h"
#import "ELLayerManagerWindowController.h"

NSString * const ELErrorDomain = @"com.lucidmac.Elysium.ErrorDomain";


NSString * const ELHasMidiDeviceKey = @"elysium.has.last.device";
NSString * const ELUsedMidiDeviceKey = @"elysium.last.device";


@implementation ElysiumController

#pragma mark Initializers

+ (void)initialize {
  NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
  
  [defaultValues setObject:[NSNumber numberWithInt:2] forKey:ELBehaviourAtOpenKey];
  [defaultValues setObject:[NSNumber numberWithFloat:0.5] forKey:ELLayerThreadPriorityKey];
  
  [defaultValues setObject:@"" forKey:ELComposerNameKey];
  [defaultValues setObject:@"" forKey:ELComposerEmailKey];
  
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
                    forKey:ELDefaultTokenColor];
  
  [defaultValues setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor colorWithDeviceRed:(121.0/255)
                                                                                             green:(121.0/255)
                                                                                              blue:(152.0/255)
                                                                                             alpha:0.8]]
                    forKey:ELDisabledTokenColor];
  
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


#pragma mark Properties

@synthesize inspectorController;


#pragma mark NSNibAwakening protocol

- (void)awakeFromNib {
  [ELMIDIController sharedInstance];
  if( ![self initScriptingEngine] ) {
    NSLog( @"Initialization of script engine failed." );
  }
}


#pragma mark NSApp delegates

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)_sender_ {
  return [[NSUserDefaults standardUserDefaults] integerForKey:ELBehaviourAtOpenKey] == EL_OPEN_EMPTY;
}


- (void)applicationWillTerminate:(NSNotification *)notification {
  for( ElysiumDocument *document in [[NSDocumentController sharedDocumentController] documents] ) {
    [[document player] stop:self];
  }
}


- (void)applicationDidFinishLaunching:(NSNotification *)_notification_ {
  if( [[NSUserDefaults standardUserDefaults] integerForKey:ELBehaviourAtOpenKey] == EL_OPEN_LAST ) {
    NSArray *recentDocuments = [[NSDocumentController sharedDocumentController] recentDocumentURLs];
    if( [recentDocuments count] > 0 ) {
      [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:[recentDocuments objectAtIndex:0] display:YES];
    } else {
      [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
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

- (IBAction)showPreferences:(id)_sender_ {
  if( !preferencesController ) {
    preferencesController = [[ELPreferencesController alloc] init];
  }
  
  [preferencesController showWindow:self];
}


- (IBAction)showMIDIConfigInspector:(id)_sender_ {
  if( !midiConfigController ) {
    midiConfigController = [[ELMIDIConfigController alloc] initWithPlayer:[self activePlayer]];
  }
  
  [midiConfigController showWindow:self];
}


- (IBAction)showHelp:(id)_sender_ {
  NSString *helpPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"output"];
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"file://%@", helpPath]]];
}


- (IBAction)visitSupportPage:(id)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://getsatisfaction.com/lucidmac/products/lucidmac_elysium"]];
}


- (IBAction)visitHomePage:(id)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://lucidmac.com/products/elysium"]];
}


- (IBAction)visitTwitterPage:(id)sender {
  [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/elysiumapp"]];
}


- (IBAction)showInspectorPanel:(id)sender {
  if( !inspectorController ) {
    inspectorController = [[ELInspectorController alloc] init];
  }
  
  [inspectorController showWindow:sender];
}


- (IBAction)inspectPlayer:(id)sender {
  [self showInspectorPanel:sender];
  [inspectorController inspect:@"player"];
}


- (IBAction)inspectLayer:(id)sender {
  [self showInspectorPanel:sender];
  [inspectorController inspect:@"layer"];
}


- (IBAction)showLayerManager:(id)sender {
  if( !layerManager ) {
    layerManager = [[ELLayerManagerWindowController alloc] init];
  }
  
  [layerManager showWindow:sender];
}


- (IBAction)showCompositionManager:(id)sender {
  if( !compositionManager ) {
    compositionManager = [[ELCompositionManager alloc] init];
  }
  
  [compositionManager showWindow:sender];
}


- (IBAction)showScriptPackageInspector:(id)sender {
  if( !scriptPackageController ) {
    scriptPackageController = [[ELScriptPackageController alloc] init];
  }
  
  [scriptPackageController showWindow:sender];
}


@end
