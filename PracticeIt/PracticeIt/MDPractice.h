//
//  MDPractice.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

@import Foundation;
#import "MDTask.h"
#import "MDPracticeDelegate.h"

@interface MDPractice : NSObject

@property NSString *title;
@property NSString *desc;
@property NSString *iconName;
@property NSMutableArray *tasks;
@property NSObject <MDPracticeDelegate> *delegate;

@property NSInteger currentTaskIndex;
@property NSTimer *timer;

-(BOOL)isPaused;
-(BOOL)isStopped;

-(BOOL)start;
-(BOOL)resume;
-(BOOL)pause;
-(BOOL)reset;

-(BOOL)nextTask;
-(BOOL)previousTask;

-(MDTask*)taskAtIndex:(NSInteger)index;
-(MDTask*)currentTask;
-(NSInteger)taskCount;
-(BOOL)removeTaskAtIndex:(NSInteger)index;
-(BOOL)addTaskWithTitle:(NSString *)title WithTTSMessage:(NSString*)ttsMessage WithAudio:(MPMediaItem*)audio WithTime:(NSTimeInterval)time;

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;

@end
