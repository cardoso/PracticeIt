//
//  MDPracticeItDelegate.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPractice.h"

@protocol MDPracticeItDelegate <NSObject>

-(void)practiceIt:(id)practiceIt didAddPractice:(MDPractice*)practice;

-(BOOL)practiceIt:(id)practiceIt shouldRemovePractice:(MDPractice*)practice;
-(void)practiceIt:(id)practiceIt willRemovePractice:(MDPractice*)practice;


-(void)practiceIt:(id)practiceIt didEditPractice:(MDPractice*)practice;

@end
