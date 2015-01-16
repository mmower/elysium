//
//  ELScriptEngine.m
//  Elysium
//
//  Created by Matt Mower on 01/10/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELScriptEngine.h"

#import <JSCocoa/JSCocoa.h>

#import "ELPlayer.h"


@interface ELScriptEngine (PrivateMethods)

- (void)loadLibraries;
+ (NSString *)appSupportPath;
+ (NSString *)defaultLibraryPath;
+ (NSString *)userLibraryPath;

@end


@implementation ELScriptEngine

#pragma mark Class initializer

+ (void)initialize {
    static BOOL initialized = NO;
    
    if (!initialized) {
        initialized = YES;
        [[BridgeSupportController sharedController] loadBridgeSupport:[[NSBundle mainBundle] pathForResource:@"Elysium" ofType:@"bridgesupport"]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self appSupportPath]]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:[self appSupportPath] withIntermediateDirectories:NO attributes:nil error:nil];
        }
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[self userLibraryPath]]) {
            [@"// Elysium user library" writeToFile :[self userLibraryPath] atomically : NO encoding : NSASCIIStringEncoding error : &error];
        }
    }
}

#pragma mark Properties

@synthesize js = _js;


#pragma mark Object initializer

- (id)initForPlayer:(ELPlayer *)player {
    if ((self = [super init])) {
        _js = [[JSCocoa alloc] init];
        [_js setObject:player withName:@"__player"];
        [self loadLibraries];
    }
    
    return self;
}

#pragma mark Object behaviours

- (void)loadLibraries {
    // NSLog(@"fATAL - ELScripEngine - loadLibraries line coded out to load default library");
    // [_js evalJSFile:[[self class] defaultLibraryPath]];
    [_js evalJSFile:[[self class] userLibraryPath]];
}

+ (NSString *)appSupportPath {
    static NSString *appSupportPath = nil;
    
    if (!appSupportPath) {
        NSArray *searchPathes = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *appSupportRoot = [searchPathes objectAtIndex:0];
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleExecutable"];
        appSupportPath = [appSupportRoot stringByAppendingPathComponent:appName];
    }
    
    return appSupportPath;
}

+ (NSString *)defaultLibraryPath {
    return [[NSBundle mainBundle] pathForResource:@"default" ofType:@"js"];
}

+ (NSString *)userLibraryPath {
    return [[self appSupportPath] stringByAppendingPathComponent:@"userlib.js"];
}

@end
