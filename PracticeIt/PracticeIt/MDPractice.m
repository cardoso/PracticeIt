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

- (BOOL)start {
    [self startTimer];
    
    return YES;
}

- (void)timerTick {
    
    if(!self.isPaused && self.currentTaskIndex == -1) {
        self.currentTaskIndex = 0;
        
        [self.delegate practice:self didStartTask:[self currentTask]];
        [self.delegate onPracticeStarted];
    }
    
    [self currentTask].currentTime++;
    
    if([self currentTask].currentTime > [self currentTask].time) {
        [self.delegate practice:self willFinishTask:[self currentTask]];
        
        self.currentTaskIndex++;
        
        if(self.currentTaskIndex < [self.tasks count])
            [self.delegate practice:self didStartTask:[self currentTask]];
        else {
            self.currentTaskIndex = -1;
            [self stopTimer];
            
            [self.delegate onPracticeFinished];
        }
    }
    
    [self.delegate onTimerTick];
}

-(BOOL)pause {
    if(self.isPaused)
        return NO;
    
    [self stopTimer];
    
    self.isPaused = YES;
    return YES;
}

-(BOOL)resume {
    if(!self.isPaused)
        return NO;
    
    [self startTimer];
    
    self.isPaused = NO;
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

    return NO;
}

-(BOOL)previousTask {

    return NO;
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

-(BOOL)startTask:(MDTask*)task {
    task.currentTime = 0;
    
    [self.delegate practice:self didStartTask:task];
    
    return YES;
}

-(MDTask *)taskAtIndex:(NSInteger)index{
    return [self.tasks objectAtIndex:index];
}

-(NSInteger)taskCount {
    return [self.tasks count];
}

-(BOOL)removeTaskAtIndex:(NSInteger)index {
    if(index >= [self.tasks count])
        return NO;
    
    MDTask *task = [self.tasks objectAtIndex:index];
    
    if([self.delegate practice:self shouldRemoveTask:task]) {
        [self.delegate practice:self willRemoveTask:task];
        [self.tasks removeObject:task];
        return YES;
    }
    
    return NO;
}

-(BOOL)addTaskWithTitle:(NSString *)title WithTTSMessage:(NSString*)ttsMessage WithAudio:(MPMediaItem*)audio WithTime:(NSTimeInterval)time {
    
    MDTask *task = [[MDTask alloc] initWithTitle:title WithTTSMessage:ttsMessage WithAudio:audio WithTime:time];
    
    [self.tasks addObject:task];
    
    [self.delegate onTaskAdded:task];
    
    return YES;
}

#pragma mark - Helper Methods

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval {
    int hours = (int)(timeInterval/3600.0f);
    int minutes = ((int)timeInterval - (hours * 3600))/60;
    int seconds = fmod(timeInterval, 60);
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

@end
