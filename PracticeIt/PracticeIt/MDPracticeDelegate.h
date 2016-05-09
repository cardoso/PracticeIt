//
//  MDPracticeDelegate.h
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPractice.h"

@protocol MDPracticeDelegate <NSObject>

-(void)onPracticeStarted;
-(void)onPracticeFinished;
-(void)onTaskAdded:(MDTask*)task;
-(void)onTimerTick;


-(BOOL)practice:(id)practice shouldRemoveTask:(MDTask*)task;
-(void)practice:(id)practice willRemoveTask:(MDTask*)task;

-(void)practice:(id)practice willFinishTask:(MDTask*)task;
-(void)practice:(id)practice didStartTask:(MDTask*)task;

@end
