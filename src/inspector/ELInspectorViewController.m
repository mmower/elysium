//
//  ELInspectorViewController.m
//  Elysium
//
//  Created by Matt Mower on 09/02/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import "ELInspectorViewController.h"

#import "ELDial.h"

#import "ELInspectorController.h"

#import "NSString+ELHelpers.h"

@implementation ELInspectorViewController

- (id)initWithInspectorController:(ELInspectorController *)aController nibName:(NSString *)aNibName target:(id)target path:(NSString *)path {
  if( ( self = [super initWithNibName:aNibName bundle:nil] ) ) {
    [self setInspectorController:aController];
    
    NSObjectController *objController = [[NSObjectController alloc] init];
    [objController bind:@"contentObject" toObject:target withKeyPath:path options:nil];
    [self setObjectController:objController];
  }
  
  return self;
}


@synthesize inspectorController;
@synthesize objectController;

- (void)bindDial:(NSString *)dialName {
  [self bindControl:dialName];
  [self bindMode:dialName];
  [self bindOsc:dialName];
}


- (void)bindControl:(NSString *)dialName {
  id control = [self valueForKey:[NSString stringWithFormat:@"%@Control",dialName]];
  
  NSArray *bindings = [control exposedBindings];
  
  [control unbind:@"enabled"];
  [control unbind:@"minimum"];
  [control unbind:@"maximum"];
  [control unbind:@"stepping"];
  [control unbind:@"toolTip"];
  [control unbind:@"value"];
  
  if( [bindings containsObject:@"enabled"] ) {
    [control bind:@"enabled"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.mode",dialName]
          options:[NSDictionary dictionaryWithObject:dialModeValueTransformer forKey:NSValueTransformerNameBindingOption]];
  }
  if( [bindings containsObject:@"minimum"] ) {
    [control bind:@"minimum"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.min",dialName]
          options:nil];
  }

  if( [bindings containsObject:@"maximum"] ) {
    [control bind:@"maximum"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.max",dialName]
          options:nil];
  }

  if( [bindings containsObject:@"stepping"] ) {
    [control bind:@"stepping"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.step",dialName]
          options:nil];
  }

  if( [bindings containsObject:@"toolTip"] ) {
    [control bind:@"toolTip"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.toolTip",dialName]
          options:nil];
  }

  if( [bindings containsObject:@"value"] ) {
    [control bind:@"value"
         toObject:[self objectController]
      withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.value",dialName]
          options:nil];
  }
}


- (void)bindMode:(NSString *)dialName {
  id control = [self valueForKey:[NSString stringWithFormat:@"%@ModeControl",dialName]];
  
  [control bind:@"selectedIndex"
       toObject:[self objectController]
    withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.mode",dialName]
        options:nil];
  
  [control bind:@"segment1enabled"
       toObject:[self objectController]
    withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.oscillator",dialName]
        options:[NSDictionary dictionaryWithObject:@"NSIsNotNil" forKey:NSValueTransformerNameBindingOption]];
}


- (void)bindOsc:(NSString *)dialName {
  id control = [self valueForKey:[NSString stringWithFormat:@"%@OscControl",dialName]];
  
  [control bind:@"target"
       toObject:[self inspectorController]
    withKeyPath:@"self"
        options:[NSDictionary dictionaryWithObject:@"editOscillator:" forKey:NSSelectorNameBindingOption]];
  
  [control bind:@"argument"
       toObject:[self objectController]
    withKeyPath:[NSString stringWithFormat:@"selection.%@Dial",dialName]
        options:nil];
        
  [control bind:@"image"
       toObject:[self objectController]
    withKeyPath:[NSString stringWithFormat:@"selection.%@Dial.oscillator",dialName]
        options:[NSDictionary dictionaryWithObject:dialHasOscillatorValueTransformer forKey:NSValueTransformerNameBindingOption]];
}


- (void)bindScript:(NSString *)scriptName {
  id control = [self valueForKey:[NSString stringWithFormat:@"edit%@Control",[scriptName initialCapitalString]]];
  
  [control bind:@"target"
       toObject:[self inspectorController]
    withKeyPath:@"self"
        options:[NSDictionary dictionaryWithObject:@"editCallback:tag:" forKey:NSSelectorNameBindingOption]];
  
  [control bind:@"argument"
       toObject:[self objectController]
    withKeyPath:@"content"
        options:nil];
  
  [control bind:@"argument2"
       toObject:control
    withKeyPath:@"tag"
        options:nil];
  
  // bind image
  
  control = [self valueForKey:[NSString stringWithFormat:@"remove%@Control",[scriptName initialCapitalString]]];
  
  [control bind:@"target"
       toObject:[self inspectorController]
    withKeyPath:@"self"
        options:[NSDictionary dictionaryWithObject:@"removeCallback:tag:" forKey:NSSelectorNameBindingOption]];
  
  [control bind:@"argument"
       toObject:[self objectController]
    withKeyPath:@"content"
        options:nil];
  
  [control bind:@"argument2"
       toObject:control
    withKeyPath:@"tag"
        options:nil];
  
  [control bind:@"hidden"
       toObject:[self objectController]
    withKeyPath:[NSString stringWithFormat:@"selection.scripts.%@",scriptName]
        options:[NSDictionary dictionaryWithObject:@"NSIsNil" forKey:NSValueTransformerNameBindingOption]];
}


@end
