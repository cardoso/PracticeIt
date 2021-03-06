//
//  MDTask.m
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDTask.h"

@implementation MDTask

- (instancetype)initWithTitle:(NSString*)title WithTTSMessage:(NSString*)ttsMessage WithAudio:(MPMediaItem*)audio WithTime:(NSTimeInterval)time
{
    self = [super init];
    if (self) {
        self.title = title;
        self.ttsMessage = ttsMessage;
        self.audio = audio;
        self.time = time;
    }
    return self;
}


@end
