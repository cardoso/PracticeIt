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

-(MDPractice*)getPracticeAtIndex:(NSInteger)index;
-(BOOL)removePracticeAtIndex:(NSInteger)index;
-(BOOL)addPracticeWithTitle:(NSString*)title WithDescription:(NSString*)description WithIconName:(NSString*)iconName;

@end
