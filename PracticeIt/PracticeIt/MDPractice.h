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

-(BOOL)startTaskAtIndex:(NSInteger)index;

-(MDTask*)taskAtIndex:(NSInteger)index;
-(NSInteger)indexForTask:(MDTask*)task;

-(MDTask*)currentTask;
-(NSInteger)taskCount;
-(BOOL)removeTaskAtIndex:(NSInteger)index;
-(BOOL)addTaskWithTitle:(NSString *)title withTtsMessage:(NSString*)ttsMessage withAudio:(MPMediaItem*)audio withTime:(NSTimeInterval)time;
-(BOOL)editTaskAtIndex:(NSInteger)index withNewTitle:(NSString*)newTitle withNewTtsMessage:(NSString*)newTtsMessage withNewAudio:(MPMediaItem*)newAudio withNewTime:(NSTimeInterval)newTime;
-(BOOL)moveTaskAtIndex:(NSInteger)index toIndex:(NSInteger)targetIndex;

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval;

@end
