//
//  MDPractice.m
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPractice.h"

@implementation MDPractice

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tasks = [NSMutableArray array];
        self.currentTaskIndex = -1;
    }
    return self;
}

-(BOOL)isPaused {
    return ![self.timer isValid] && self.currentTaskIndex > -1;
}

-(BOOL)isStopped {
    return ![self.timer isValid] && self.currentTaskIndex == -1;
}

- (BOOL)start {
    [self startTimer];
    
    return YES;
}

- (void)timerTick {
    
    if(self.currentTaskIndex == -1) {
        self.currentTaskIndex = 0;
        
        [self.delegate didStartPractice:self];
    }
    
    if([self currentTask].currentTime == 0)
        [self.delegate practice:self didStartTask:[self currentTask]];
    
    [self currentTask].currentTime++;
    
    if([self currentTask].currentTime > [self currentTask].time) {
        [self.delegate practice:self willFinishTask:[self currentTask]];
        
        self.currentTaskIndex++;
        
        if(self.currentTaskIndex >= [self.tasks count]) {
            self.currentTaskIndex = -1;
            [self stopTimer];
            
            [self.delegate didFinishPractice:self];
        }
    }
    
    [self.delegate didTimerTickOnPractice:self];
}

/*- (BOOL)timerTick {
    if(self.isPaused){
        return NO;
    }
    if(self.currentTaskIndex == -1){
        self.currentTaskIndex = 0;
        //[self.delegate practice:self didStartTask:[self currentTask]];
        [self.delegate onPracticeStarted];
    }
    [self currentTask].currentTime++;
    
    if([self currentTask].currentTime > [self currentTask].time){
        self.currentTask.currentTime = self.currentTask.time;
        self.currentTaskIndex++;
        if(self.currentTaskIndex < [self.tasks count]){
            //[self.delegate practice:self didStartTask:[self currentTask]];
        }else{
            self.currentTaskIndex = -1;
            [self stopTimer];
            [self.delegate onPracticeFinished];
        }
        
    }
    [self.delegate onTimerTick];
    return YES;
}*/

-(BOOL)pause {
    if([self isPaused])
        return NO;
    
    [self stopTimer];
    
    [self.delegate didPausePractice:self];
    
    return YES;
}

-(BOOL)resume {
    if(![self isPaused])
        return NO;
    
    [self startTimer];
    
    [self.delegate didResumePractice:self];
    
    return YES;
}

-(BOOL)reset {
    [self stopTimer];
    
    self.currentTaskIndex = -1;
    
    for(MDTask *task in self.tasks) {
        task.currentTime = 0;
    }
    
    return YES;
}

-(BOOL)nextTask {
    if(self.currentTaskIndex < 0){
        return NO;
    }
    
    if(self.currentTaskIndex+1 == [self.tasks count]){
        return NO;
    }
    
    self.currentTask.currentTime = self.currentTask.time-1;
    
    return YES;
}

-(BOOL)previousTask {
    if(self.currentTaskIndex < 0){
        return NO;
    }
    
    if(self.currentTaskIndex == 0){
        return NO;
    }
    
    [self currentTask].currentTime = -1;
    [self timerTick];
    self.currentTaskIndex--;
    [self currentTask].currentTime = 0;
    
    return YES;
}

-(void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [self.timer invalidate];
}

-(MDTask *)currentTask {
    if(self.currentTaskIndex < 0 || self.currentTaskIndex >= [self.tasks count])
        return nil;
    
    return [self.tasks objectAtIndex:self.currentTaskIndex];
}

-(BOOL)startTaskAtIndex:(NSInteger)index {
    MDTask *task = [self taskAtIndex:index];
    
    if(task) {
        task.currentTime = 0;
        self.currentTaskIndex = index;
    
        [self.delegate practice:self didStartTask:task];
    
        return YES;
    }
    
    return NO;
}

-(MDTask *)taskAtIndex:(NSInteger)index{
    return [self.tasks objectAtIndex:index];
}

-(NSInteger)indexForTask:(MDTask *)task {
    for(int i = 0; i < [self taskCount]; i++)
        if(self.tasks[i] == task)
            return i;
    
    return -1;
}

-(NSInteger)taskCount {
    return [self.tasks count];
}

-(BOOL)removeTaskAtIndex:(NSInteger)index {
    if(index >= [self taskCount])
        return NO;
    
    MDTask *task = [self.tasks objectAtIndex:index];
    
    if(![self.delegate practice:self shouldRemoveTask:task])
        return NO;
    
    [self.delegate practice:self willRemoveTask:task];
    [self.tasks removeObject:task];
    
    return YES;
}

-(BOOL)addTaskWithTitle:(NSString *)title withTtsMessage:(NSString*)ttsMessage withAudio:(MPMediaItem*)audio withTime:(NSTimeInterval)time {
    
    MDTask *task = [[MDTask alloc] initWithTitle:title WithTTSMessage:ttsMessage WithAudio:audio WithTime:time];
    
    if([self.delegate practice:self shouldAddTask:task]) {
        [self.tasks addObject:task];
    
        [self.delegate practice:self didAddTask:task];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)editTaskAtIndex:(NSInteger)index withNewTitle:(NSString*)newTitle withNewTtsMessage:(NSString *)newTtsMessage withNewAudio:(MPMediaItem *)newAudio withNewTime:(NSTimeInterval)newTime {
    if(index >= [self taskCount])
        return NO;
    
    MDTask *task = [self taskAtIndex:index];
    
    task.title = newTitle;
    task.ttsMessage = newTtsMessage;
    task.audio = newAudio;
    task.time = newTime;
    
    [self.delegate practice:self didEditTask:task];
    
    return YES;
}

-(BOOL)moveTaskAtIndex:(NSInteger)index toIndex:(NSInteger)targetIndex {
    
    if(index >= [self taskCount] || index < 0 || targetIndex >= [self taskCount] || index < 0)
        return NO;
    
    MDTask *task = [self taskAtIndex:index];
    
    [self.tasks removeObject:task];
    [self.tasks insertObject:task atIndex:targetIndex];
    
    return TRUE;
}

#pragma mark - Helper Methods

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    int hours = (int)(timeInterval/3600.0f);
    int minutes = ((int)timeInterval - (hours * 3600))/60;
    int seconds = fmod(timeInterval, 60);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

@end
