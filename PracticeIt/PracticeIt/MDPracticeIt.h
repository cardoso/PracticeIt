//
//  MDPracticeIt.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDPracticeItDelegate.h"
#import "MDPractice.h"

@interface MDPracticeIt : NSObject

@property NSMutableArray *practices;
@property NSObject<MDPracticeItDelegate> *delegate;


-(MDPractice*)practiceAtIndex:(NSInteger)index;
-(NSInteger)indexForPractice:(MDPractice*)practice;

-(NSInteger)practiceCount;

-(MDPractice*)addPracticeWithTitle:(NSString*)title withDescription:(NSString*)description withIconName:(NSString*)iconName;
-(BOOL)removePracticeAtIndex:(NSInteger)index;
-(BOOL)editPracticeAtIndex:(NSInteger)index withNewTitle:(NSString*)newTitle withNewDescription:(NSString*)newDescription withNewIcon:(NSString*)newIconName;
-(BOOL)movePracticeAtIndex:(NSInteger)index toIndex:(NSInteger)targetIndex;

-(BOOL)loadData;
-(BOOL)saveData;

@end
