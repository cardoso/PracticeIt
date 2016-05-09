//
//  MDTask.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MDTask : NSObject

@property NSString *title;
@property NSString *ttsMessage;
@property MPMediaItem *audio;
@property NSTimeInterval time;
@property NSTimeInterval currentTime;

- (instancetype)initWithTitle:(NSString*)title WithTTSMessage:(NSString*)ttsMessage WithAudio:(MPMediaItem*)audio WithTime:(NSTimeInterval)time;

@end
