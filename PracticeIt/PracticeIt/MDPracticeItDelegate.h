//
//  MDPracticeItDelegate.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPractice.h"

@protocol MDPracticeItDelegate <NSObject>

-(void)onPracticeAdded;
-(void)onPracticeRemoved;

-(void)practiceIt:(id)practiceIt didEditPractice:(MDPractice*)practice;

@end
