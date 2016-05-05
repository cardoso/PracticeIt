//
//  MDPracticeDelegate.h
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

@protocol MDPracticeDelegate <NSObject>

-(void)onPracticeStarted;
-(void)onPracticeFinished;
-(void)onTaskAdded;
-(void)onTaskRemoved;
-(void)onTaskStarted;
-(void)onTaskFinished;
-(void)onTimerTick;

@end
