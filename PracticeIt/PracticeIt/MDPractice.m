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
        self.synthesizer = [[AVSpeechSynthesizer alloc]init];
    }
    return self;
}

-(BOOL)start {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
    
    [self startTask:[self currentTask]];
    
    [self.delegate onPracticeStarted];

    return YES;
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
    self.currentTaskIndex = 0;
    
    for(MDTask *task in self.tasks) {
        task.currentTime = 0;
    }
    
    return YES;
}

-(BOOL)nextTask {
    if(self.currentTaskIndex < [self.tasks count]) {
        self.currentTaskIndex++;
        if(!self.isPaused)
            [self startTask:[self currentTask]];
        return YES;
    }
    
    return NO;
}

-(BOOL)previousTask {
    self.currentTaskIndex--;
    [self currentTask].currentTime = 0;
    
    if(!self.isPaused) {
            [self startTask:[self currentTask]];
        return YES;
    }
    
    return NO;
}

-(void)startTimer {
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [self.timer invalidate];
}

-(void)timerTick {
    // LOGICA DE ATUALIZAR TASK ATUAL
    MDTask *task = [self currentTask];
    
    task.currentTime++;
    
    if(task.currentTime > task.time) {
        // LOGICA DE FINALIZAR TASK ATUAL
        task.currentTime = task.time;
        
        self.currentTaskIndex++;
        
        [self.delegate onTaskFinished];
        
        if(self.currentTaskIndex >= [self taskCount]) {
            // LOGICA DE FINALIZAR PRATICA
            self.currentTaskIndex = 0;
            
            [self stopTimer];
        
            [self.delegate onPracticeFinished];

        } else if(self.currentTaskIndex < [self taskCount]) {
            // LOGICA DE INICIAR PROXIMA TASK
            [self startTask:[self taskAtIndex:self.currentTaskIndex]];
            [self.delegate onTaskStarted];
        }
        
    }
    
    [self.delegate onTimerTick];
}

-(MDTask *)currentTask {
    if(self.currentTaskIndex >= [self.tasks count]){
        // USUARIO APAGOU A TASK ENQUANTO EXECUTAVA
        
        [self.timer invalidate];
        self.timer = nil;
        
        return nil;
    }
    
    return [self.tasks objectAtIndex:self.currentTaskIndex];
}

-(BOOL)startTask:(MDTask*)task {
    task.currentTime = 0;
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:task.ttsMessage];
    [utterance setRate:0.4f];
    [self.synthesizer speakUtterance:utterance];
    
    return YES;
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
