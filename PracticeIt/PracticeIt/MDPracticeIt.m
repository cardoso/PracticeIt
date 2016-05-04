//
//  MDPracticeIt.m
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDPracticeIt.h"

@implementation MDPracticeIt

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.practices = [NSMutableArray array];
    }
    return self;
}

-(MDPractice *)getPracticeAtIndex:(NSInteger)index {
    return [self.practices objectAtIndex:index];
}

-(BOOL)removePracticeAtIndex:(NSInteger)index {
    if(index < [self.practices count]) {
        [self.practices removeObjectAtIndex:index];
        
        [self.delegate onPracticeRemoved];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)addPracticeWithTitle:(NSString *)title WithDescription:(NSString *)description WithIconName:(NSString *)iconName {
    MDPractice *practice = [[MDPractice alloc] init];
    
    practice.title = title;
    practice.desc = description;
    practice.iconName = iconName;
    
    [self.practices addObject:practice];
    
    [self.delegate onPracticeAdded];
    
    return YES;
}

@end
