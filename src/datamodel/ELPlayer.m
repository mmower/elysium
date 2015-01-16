//
//  ELPlayer.m
//  Elysium
//
//  Created by Matt Mower on 20/07/2008.
//  Copyright 2008 Matthew Mower.
//  See MIT-LICENSE for more information.
//

//#import <CoreAudio/HostTime.h>

#import "Elysium.h"

#define USE_TRIGGER_THREAD NO

#import "ELPlayer.h"

#import "ELCell.h"
#import "ELNote.h"
#import "ELLayer.h"
#import "ElysiumDocument.h"
#import "ELHarmonicTable.h"
#import "ElysiumController.h"
#import "ELScriptEngine.h"
#import "ELScriptPackage.h"

#import "ELMIDIMessage.h"
#import "ELMIDIController.h"
#import "ELMIDINoteMessage.h"
#import "ELOscillatorController.h"

#import "ELToken.h"
#import "ELNoteToken.h"
#import "ELGenerateToken.h"

#import "ELOscillator.h"

#import "ELDialBank.h"

@implementation ELPlayer

#pragma mark Initializers

- (id)init {
    if ((self = [super init])) {
        _loaded               = NO;
        _harmonicTable        = [[ELHarmonicTable alloc] init];
        _layers               = [[NSMutableArray alloc] init];
        _selectedLayer        = nil;
        
        [self setTempoDial:[ELDialBank defaultTempoDial]];
        [self setBarLengthDial:[ELDialBank defaultBarLengthDial]];
        [self setTimeToLiveDial:[ELDialBank defaultTimeToLiveDial]];
        [self setPulseEveryDial:[ELDialBank defaultPulseEveryDial]];
        [self setVelocityDial:[ELDialBank defaultVelocityDial]];
        [self setEmphasisDial:[ELDialBank defaultEmphasisDial]];
        [self setTempoSyncDial:[ELDialBank defaultTempoSyncDial]];
        [self setNoteLengthDial:[ELDialBank defaultNoteLengthDial]];
        [self setTransposeDial:[ELDialBank defaultTransposeDial]];
        
        _oscillatorController = [[ELOscillatorController alloc] init];
        
        _scriptingTag         = @"player";
        _scripts              = [NSMutableDictionary dictionary];
        _triggers             = [[NSMutableArray alloc] init];
        _scriptEngine         = [[ELScriptEngine alloc] initForPlayer:self];
        _pkg                  = [[ELScriptPackage alloc] initWithPlayer:self];
        
        _nextLayerNumber      = 1;
        
        // Note that we start this here, otherwise MIDI CC cannot be used to trigger the player itself
        if (USE_TRIGGER_THREAD) {
            _triggerThread = [[NSThread alloc] initWithTarget:self selector:@selector(triggerMain) object:nil];
            [_triggerThread start];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:ELNotifyPlayerShouldStart object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:ELNotifyPlayerShouldStop object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMIDIControlMessage:) name:ELNotifyMIDIControl object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMIDINoteMessage:) name:ELNotifyMIDINote object:nil];
        
        _loaded = YES;
    }
    
    return self;
}

// There is an issue here!
- (id)initWithDocument:(ElysiumDocument *)document {
    if ((self = [self init])) {
        [self setDocument:document];
    }
    
    return self;
}

- (id)initWithDocument:(ElysiumDocument *)document createDefaultLayer:(BOOL)shouldCreateDefaultLayer {
    if ((self = [self initWithDocument:document])) {
        if (shouldCreateDefaultLayer) {
            [self createLayer];
        }
    }
    
    return self;
}

#pragma mark Properties

@synthesize harmonicTable = _harmonicTable;
@synthesize layers = _layers;
@synthesize dirty = _dirty;
@synthesize oscillatorController = _oscillatorController;


@synthesize tempoDial = _tempoDial;

- (void)setTempoDial:(ELDial *)tempoDial {
    _tempoDial = tempoDial;
    [_tempoDial setDelegate:self];
}

@synthesize barLengthDial = _barLengthDial;

- (void)setBarLengthDial:(ELDial *)barLengthDial {
    _barLengthDial = barLengthDial;
    [_barLengthDial setDelegate:self];
}

@synthesize timeToLiveDial = _timeToLiveDial;

- (void)setTimeToLiveDial:(ELDial *)timeToLiveDial {
    _timeToLiveDial = timeToLiveDial;
    [_timeToLiveDial setDelegate:self];
}

@synthesize pulseEveryDial = _pulseEveryDial;

- (void)setPulseEveryDial:(ELDial *)pulseEveryDial {
    _pulseEveryDial = pulseEveryDial;
    [_pulseEveryDial setDelegate:self];
}

@synthesize velocityDial = _velocityDial;

- (void)setVelocityDial:(ELDial *)velocityDial {
    _velocityDial = velocityDial;
    [_velocityDial setDelegate:self];
}

@synthesize emphasisDial = _emphasisDial;

- (void)setEmphasisDial:(ELDial *)emphasisDial {
    _emphasisDial = emphasisDial;
    [_emphasisDial setDelegate:self];
}

@synthesize tempoSyncDial = _tempoSyncDial;

- (void)setTempoSyncDial:(ELDial *)tempoSyncDial {
    _tempoSyncDial = tempoSyncDial;
    [_tempoSyncDial setDelegate:self];
}

@synthesize noteLengthDial = _noteLengthDial;

- (void)setNoteLengthDial:(ELDial *)noteLengthDial {
    _noteLengthDial = noteLengthDial;
    [_noteLengthDial setDelegate:self];
}

@synthesize transposeDial = _transposeDial;

- (void)setTransposeDial:(ELDial *)transposeDial {
    _transposeDial = transposeDial;
    [_transposeDial setDelegate:self];
}

@synthesize document = _document;
@synthesize scripts = _scripts;
@synthesize scriptingTag = _scriptingTag;
@synthesize triggers = _triggers;
@synthesize scriptEngine = _scriptEngine;
@synthesize pkg = _pkg;
@synthesize selectedLayer = _selectedLayer;
@synthesize running = _running;


- (NSUndoManager *)undoManager {
    if (_loaded) {
        return [[self document] undoManager];
    }
    else {
        return nil;
    }
}

#pragma mark Player start/stop

- (void)start:(id)sender {
    [self performSelectorOnMainThread:@selector(runWillStartScript) withObject:nil waitUntilDone:YES];
    [[self oscillatorController] startOscillators];
    [[self layers] makeObjectsPerformSelector:@selector(start)];
    [self setRunning:YES];
    [self performSelectorOnMainThread:@selector(runDidStartScript) withObject:nil waitUntilDone:YES];
}

- (void)stop:(id)sender {
    if ([self running]) {
        [self performSelectorOnMainThread:@selector(runWillStopScript) withObject:nil waitUntilDone:YES];
        [[self oscillatorController] stopOscillators];
        [[self layers] makeObjectsPerformSelector:@selector(stop)];
        [self setRunning:NO];
        [self performSelectorOnMainThread:@selector(runDidStopScript) withObject:nil waitUntilDone:YES];
    }
}

- (void)reset {
    [[self layers] makeObjectsPerformSelector:@selector(reset)];
}

- (void)clearAll {
    [[self layers] makeObjectsPerformSelector:@selector(clear)];
}

#pragma mark Scripting support

- (void)runWillStartScript {
    ELScript *script = [[self scripts] objectForKey:@"willStart"];
    [script evalWithArg:self];
}

- (void)runDidStartScript {
    [[[self scripts] objectForKey:@"didStart"] evalWithArg:self];
}

- (void)runWillStopScript {
    [[[self scripts] objectForKey:@"willStop"] evalWithArg:self];
}

- (void)runDidStopScript {
    [[[self scripts] objectForKey:@"didStop"] evalWithArg:self];
}

- (ELScript *)callbackTemplate {
    return [@"function(player) {\n\t// write your callback code here\n}\n" asJavascriptFunction :[self scriptEngine]];
}

#pragma mark Drawing Support

- (void)needsDisplay {
    [[self layers] makeObjectsPerformSelector:@selector(needsDisplay)];
}

#pragma mark Layer Management

- (ELLayer *)createLayer {
    ELLayer *layer = [self makeLayer];
    [self addLayer:layer];
    return layer;
}

- (ELLayer *)makeLayer {
    ELLayer *layer = [[ELLayer alloc] initWithPlayer:self channel:([self layerCount] + 1)];
    
    [layer setLayerId:[NSString stringWithFormat:@"Layer-%d", _nextLayerNumber++]];
    
    [[layer tempoDial] setMode:dialInherited];
    [[layer barLengthDial] setMode:dialInherited];
    [[layer velocityDial] setMode:dialInherited];
    [[layer emphasisDial] setMode:dialInherited];
    [[layer tempoSyncDial] setMode:dialInherited];
    [[layer noteLengthDial] setMode:dialInherited];
    [[layer pulseEveryDial] setMode:dialInherited];
    [[layer timeToLiveDial] setMode:dialInherited];
    [[layer transposeDial] setMode:dialInherited];
    
    return layer;
}

- (void)addLayer:(ELLayer *)layer {
    [self willChangeValueForKey:@"layers"];
    [layer setPlayer:self];
    [[self layers] addObject:layer];
    [self didChangeValueForKey:@"layers"];
}

- (void)removeLayer:(ELLayer *)layer {
    [self willChangeValueForKey:@"layers"];
    [[self layers] removeObject:layer];
    [self didChangeValueForKey:@"layers"];
}

- (int)layerCount {
    return [[self layers] count];
}

- (ELLayer *)layer:(int)index {
    return [[self layers] objectAtIndex:index];
}

- (void)removeLayers {
    for (ELLayer *layer in[[self layers] copy]) {
        [self removeLayer:layer];
    }
}

#pragma mark Incoming MIDI message support


- (void)triggerMain {
    // Without any inputs attached a runloop will automatically exit
    // This would create a spin loop that will eat a lot of CPU
    [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    
    do {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
        // [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
    while (![[NSThread currentThread] isCancelled]);
}

- (void)processMIDIControlMessage:(NSNotification *)notification {
    ELMIDIControlMessage *message = [notification object];
    
    if (USE_TRIGGER_THREAD) {
        [self performSelector:@selector(handleMIDIControlMessage:) onThread:_triggerThread withObject:message waitUntilDone:NO];
    }
    else {
        [self performSelectorOnMainThread:@selector(handleMIDIControlMessage:) withObject:message waitUntilDone:NO];
    }
}

- (void)handleMIDIControlMessage:(ELMIDIControlMessage *)message {
    [[self triggers] makeObjectsPerformSelector:@selector(handleMIDIControlMessage:) withObject:message];
}

- (void)processMIDINoteMessage:(NSNotification *)notification {
    ELMIDIControlMessage *message = [notification object];
    
    if (USE_TRIGGER_THREAD) {
        [self performSelector:@selector(handleMIDINoteMessage:) onThread:_triggerThread withObject:message waitUntilDone:NO];
    }
    else {
        [self performSelectorOnMainThread:@selector(handleMIDINoteMessage:) withObject:message waitUntilDone:NO];
    }
}

- (void)handleMIDINoteMessage:(ELMIDINoteMessage *)message {
    [[self layers] makeObjectsPerformSelector:@selector(handleMIDINoteMessage:) withObject:message];
}

#pragma mark Implements ELXmlData protocol

- (NSXMLElement *)xmlRepresentation {
    NSXMLElement *surfaceElement = [NSXMLNode elementWithName:@"surface"];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[[NSNumber numberWithInt:[[self harmonicTable] cols]] stringValue] forKey:@"columns"];
    [attributes setObject:[[NSNumber numberWithInt:[[self harmonicTable] rows]] stringValue] forKey:@"rows"];
    [surfaceElement setAttributesAsDictionary:attributes];
    
    NSXMLElement *controlsElement = [NSXMLNode elementWithName:@"controls"];
    [controlsElement addChild:[[self tempoDial] xmlRepresentation]];
    [controlsElement addChild:[[self barLengthDial] xmlRepresentation]];
    [controlsElement addChild:[[self timeToLiveDial] xmlRepresentation]];
    [controlsElement addChild:[[self pulseEveryDial] xmlRepresentation]];
    [controlsElement addChild:[[self velocityDial] xmlRepresentation]];
    [controlsElement addChild:[[self emphasisDial] xmlRepresentation]];
    [controlsElement addChild:[[self tempoSyncDial] xmlRepresentation]];
    [controlsElement addChild:[[self noteLengthDial] xmlRepresentation]];
    [controlsElement addChild:[[self transposeDial] xmlRepresentation]];
    
    [surfaceElement addChild:controlsElement];
    
    NSXMLElement *layersElement = [NSXMLNode elementWithName:@"layers"];
    for (ELLayer *layer in[self layers]) {
        [layersElement addChild:[layer xmlRepresentation]];
    }
    [surfaceElement addChild:layersElement];
    
    NSXMLElement *triggersElement = [NSXMLNode elementWithName:@"triggers"];
    for (ELMIDITrigger *trigger in[self triggers]) {
        [triggersElement addChild:[trigger xmlRepresentation]];
    }
    [surfaceElement addChild:triggersElement];
    
    NSXMLElement *scriptsElement = [NSXMLNode elementWithName:@"scripts"];
    for (NSString *name in[[self scripts] allKeys]) {
        NSXMLElement *scriptElement = [NSXMLNode elementWithName:@"script"];
        
        [attributes removeAllObjects];
        [attributes setObject:name forKey:@"name"];
        [scriptElement setAttributesAsDictionary:attributes];
        
        NSXMLNode *cdataNode = [[NSXMLNode alloc] initWithKind:NSXMLTextKind options:NSXMLNodeIsCDATA];
        [cdataNode setStringValue:[[self scripts] objectForKey:name]];
        [scriptElement addChild:cdataNode];
        
        [scriptsElement addChild:scriptElement];
    }
    [surfaceElement addChild:scriptsElement];
    
    [surfaceElement addChild:[[self pkg] xmlRepresentation]];
    
    return surfaceElement;
}

- (id)initWithXmlRepresentation:(NSXMLElement *)representation parent:(id)parent player:(ELPlayer *)player error:(NSError **)error {
    if ((self = [self init])) {
        /* At this point the document doesn't have a player, it's us! */
        player = self;
        
        NSArray *nodes;
        
        _loaded = NO;
        
        [self setTempoDial:[representation loadDial:@"tempo" parent:nil player:player error:error]];
        [self setBarLengthDial:[representation loadDial:@"barLength" parent:nil player:player error:error]];
        [self setTimeToLiveDial:[representation loadDial:@"timeToLive" parent:nil player:player error:error]];
        [self setPulseEveryDial:[representation loadDial:@"pulseEvery" parent:nil player:player error:error]];
        [self setVelocityDial:[representation loadDial:@"velocity" parent:nil player:player error:error]];
        [self setEmphasisDial:[representation loadDial:@"emphasis" parent:nil player:player error:error]];
        [self setTempoSyncDial:[representation loadDial:@"tempoSync" parent:nil player:player error:error]];
        [self setNoteLengthDial:[representation loadDial:@"noteLength" parent:nil player:player error:error]];
        [self setTransposeDial:[representation loadDial:@"transpose" parent:nil player:player error:error]];
        
        // Layers
        nodes = [representation nodesForXPath:@"layers/layer" error:error];
        if (nodes == nil) {
            return nil;
        }
        else {
            for (NSXMLNode *node in nodes) {
                ELLayer *layer = [[ELLayer alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:self player:self error:error];
                if (layer == nil) {
                    return nil;
                }
                else {
                    [self addLayer:layer];
                    _nextLayerNumber++; // Ensure that future defined layers don't get a duplicate id.
                }
            }
        }
        
        // Triggers
        nodes = [representation nodesForXPath:@"triggers/trigger" error:error];
        if (nodes == nil) {
            return nil;
        }
        else {
            for (NSXMLNode *node in nodes) {
                ELMIDITrigger *trigger = [[ELMIDITrigger alloc] initWithXmlRepresentation:((NSXMLElement *)node) parent:nil player:self error:error];
                if (trigger == nil) {
                    return nil;
                }
                else {
                    [[self triggers] addObject:trigger];
                }
            }
        }
        
        // Scripts
        nodes = [representation nodesForXPath:@"scripts/script" error:error];
        if (nodes == nil) {
            return nil;
        }
        else {
            for (NSXMLNode *node in nodes) {
                NSXMLElement *element = (NSXMLElement *)node;
                [[self scripts] setObject:[[element stringValue] asJavascriptFunction:[self scriptEngine]]
                                   forKey:[element attributeAsString:@"name"]];
            }
        }
        
        // Convenient, even though there should only ever be one
        nodes = [representation nodesForXPath:@"package" error:error];
        if (nodes == nil) {
            return nil;
        }
        else {
            NSXMLElement *element;
            if ((element = [nodes firstXMLElement])) {
                _pkg = [[ELScriptPackage alloc] initWithXmlRepresentation:element parent:nil player:self error:error];
                if (_pkg == nil) {
                    return nil;
                }
            }
        }
        
        _loaded = YES;
    }
    
    return self;
}

@end
