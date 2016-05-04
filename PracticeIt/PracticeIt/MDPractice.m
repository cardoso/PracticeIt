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

-(BOOL)addTaskWithTitle:(NSString *)title WithTime:(NSTimeInterval *)time {
    MDTask *task = [[MDTask alloc] initWithTitle:title WithTime:time];
    [self.tasks addObject:task];
    return YES;
}

@end
