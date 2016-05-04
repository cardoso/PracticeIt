//
//  MDTask.h
//  PracticeIt
//
//  Created by bepid on 5/4/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDTask : NSObject

@property NSString *title;
@property NSString *ttsMessage;
@property NSString *audioPlaceholder;
@property NSTimeInterval *time;

- (instancetype)initWithTitle:(NSString*)title WithTime:(NSTimeInterval*)time;
@end
