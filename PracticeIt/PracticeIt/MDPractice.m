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
    }
    return self;
}

-(BOOL)start {
    self.currentTaskIndex = 0;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    
    
    [self.delegate onPracticeStarted];
    
    return YES;
}

-(void)timerTick {
    // LOGICA DE ATUALIZAR TASK ATUAL
    
    MDTask *task = [self currentTask];
    
    task.currentTime++;
    
    if(task.currentTime > task.time) {
        // LOGICA DE FINALIZAR TASK ATUAL
        
        [self.delegate onTaskFinished];
        
        self.currentTaskIndex++;
        
        if(self.currentTaskIndex >= [self taskCount]) {
            
            // LOGICA DE FINALIZAR PRATICA
            
            [self.delegate onPracticeFinished];
            [self.timer invalidate];
        } else {
            
            // LOGICA DE INICIAR PROXIMA TASK
            
            [self.delegate onTaskStarted];
        }
    }
    
    [self.delegate onTimerTick];
}

-(MDTask *)currentTask {
    return [self.tasks objectAtIndex:self.currentTaskIndex];
}

-(MDTask *)taskAtIndex:(NSInteger)index{
    return [self.tasks objectAtIndex:index];
}

-(NSInteger)taskCount {
    return [self.tasks count];
}

-(BOOL)removeTaskAtIndex:(NSInteger)index {
    if(index < [self.tasks count]) {
        [self.tasks removeObjectAtIndex:index];
        
        [self.delegate onTaskRemoved];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)addTaskWithTitle:(NSString *)title WithTTSMessage:(NSString*)ttsMessage WithAudio:(NSString*)audio WithTime:(NSTimeInterval)time {
    
    MDTask *task = [[MDTask alloc] initWithTitle:title WithTTSMessage:ttsMessage WithAudio:audio WithTime:time];
    [self.tasks addObject:task];
    
    [self.delegate onTaskAdded];
    
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
