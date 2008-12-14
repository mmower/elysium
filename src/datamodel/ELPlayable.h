//
//  ELPlayable.h
//  Elysium
//
//  Created by Matt Mower on 18/10/2008.
//  Copyright 2008 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ELMIDIMessage;

@interface ELPlayable : NSObject {
}

- (void)playOnChannel:(int)channel
             duration:(float)duration
             velocity:(int)velocity
            transpose:(int)transpose;
            
- (void)playOnChannel:(int)channel
             duration:(float)duration
             velocity:(int)velocity
            transpose:(int)transpose
               offset:(int)offset;

- (void)prepareMIDIMessage:(ELMIDIMessage*)message
                   channel:(int)channel
                    onTime:(UInt64)onTime
                   offTime:(UInt64)offTime
                  velocity:(int)velocity
                 transpose:(int)transpose;

@end
