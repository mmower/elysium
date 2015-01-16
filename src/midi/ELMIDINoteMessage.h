//
//  ELMIDINoteMessage.h
//  Elysium
//
//  Created by Matt Mower on 25/06/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ELMIDINoteMessage : NSObject {
  Byte  _channel;
  Byte  _note;
  Byte  _velocity;
  BOOL  _noteOn;
}

- (id)initWithChannel:(Byte)channel note:(Byte)note velocity:(Byte)velocity noteOn:(BOOL)noteOn;

@property Byte channel;
@property Byte note;
@property Byte velocity;
@property  (nonatomic) BOOL noteOn;

- (BOOL)matchesChannelMask:(Byte)channelMask;

@end
