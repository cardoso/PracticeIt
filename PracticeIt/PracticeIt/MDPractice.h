//
//  MDPractice.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDTask.h"

@interface MDPractice : NSObject

@property NSString *title;
@property NSString *desc;
@property NSString *iconName;
@property NSMutableArray *tasks;

-(BOOL)addTaskWithTitle: (NSString*)title WithTime:(NSTimeInterval*)time;

@end
