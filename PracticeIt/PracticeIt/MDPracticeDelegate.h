//
//  MDPracticeDelegate.h
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPractice.h"

@protocol MDPracticeDelegate <NSObject>

-(void)didTimerTickOnPractice:(id)practice;

-(void)didPausePractice:(id)practice;
-(void)didResumePractice:(id)practice;

-(void)didStartPractice:(id)practice;
-(void)didFinishPractice:(id)practice;

-(BOOL)practice:(id)practice shouldAddTask:(MDTask*)task;
-(void)practice:(id)practice didAddTask:(MDTask*)task;

-(BOOL)practice:(id)practice shouldRemoveTask:(MDTask*)task;
-(void)practice:(id)practice willRemoveTask:(MDTask*)task;
-(void)practice:(id)practice didRemoveTask:(MDTask*)task;

-(void)practice:(id)practice didEditTask:(MDTask*)task;

-(void)practice:(id)practice willFinishTask:(MDTask*)task;
-(void)practice:(id)practice didStartTask:(MDTask*)task;

@end
