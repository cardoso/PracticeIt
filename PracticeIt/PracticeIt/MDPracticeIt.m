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
        [self loadData];
    }
    return self;
}

-(MDPractice *)practiceAtIndex:(NSInteger)index {
    if(index < 0 || index >= [self.practices count])
        return nil;
    
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

-(MDPractice*)addPracticeWithTitle:(NSString *)title WithDescription:(NSString *)description WithIconName:(NSString *)iconName {
    MDPractice *practice = [[MDPractice alloc] init];
    
    practice.title = title;
    practice.desc = description;
    practice.iconName = iconName;
    
    [self.practices addObject:practice];
    
    [self.delegate onPracticeAdded];
    
    return practice;
}

-(BOOL)loadData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"practices.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"practices" ofType:@"plist"];
    }
    
    NSArray *arrPractices = [NSArray arrayWithContentsOfFile:plistPath];
    
    for(NSDictionary *dictPractice in arrPractices) {
        NSString *title = [dictPractice objectForKey:@"title"];
        NSString *desc = [dictPractice objectForKey:@"desc"];
        NSString *iconName = [dictPractice objectForKey:@"iconName"];
        
        MDPractice *pract = [self addPracticeWithTitle:title WithDescription:desc WithIconName:iconName];
        
        NSArray *arrTasks = [dictPractice objectForKey:@"tasks"];
        
        for(NSDictionary *dictTask in arrTasks) {
            NSString *title = [dictTask objectForKey:@"title"];
            NSString *ttsMessage = [dictTask objectForKey:@"ttsMessage"];
            NSNumber *audioId = [dictTask objectForKey:@"audio"];
            NSNumber *time = [dictTask objectForKey:@"time"];
            
            MPMediaQuery *query = [MPMediaQuery songsQuery];
            MPMediaPropertyPredicate *predicate = [MPMediaPropertyPredicate predicateWithValue:audioId forProperty:MPMediaItemPropertyPersistentID];
            [query addFilterPredicate:predicate];
            NSArray *mediaItems = [query items];
            //this array will consist of song with given persistentId. add it to collection and play it
            MPMediaItemCollection *col = [[MPMediaItemCollection alloc] initWithItems:mediaItems];
            ///....
            
            
            MPMediaItem *audio = nil;
            if([col count] > 0)
                audio = col.items[0];
            
            [pract addTaskWithTitle:title WithTTSMessage:ttsMessage WithAudio:audio WithTime:time.doubleValue];
        }
        
    }
    
    return YES;
}

-(BOOL)saveData {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"practices.plist"];
    
    NSMutableArray *arrPractices = [NSMutableArray array];
    
    for(MDPractice *practice in self.practices) {
        
        NSDictionary *dictPractice = [NSMutableDictionary dictionary];
        
        [dictPractice setValue:practice.title forKey:@"title"];
        [dictPractice setValue:practice.desc forKey:@"desc"];
        [dictPractice setValue:practice.iconName forKey:@"iconName"];
        
        NSMutableArray *arrTasks = [NSMutableArray array];
        
        for(MDTask *task in practice.tasks) {
            NSMutableDictionary *dictTask = [NSMutableDictionary dictionary];
            
            [dictTask setValue:task.title forKey:@"title"];
            [dictTask setValue:task.ttsMessage forKey:@"ttsMessage"];
            [dictTask setValue:[NSNumber numberWithUnsignedLongLong:task.audio.persistentID] forKey:@"audio"];
            [dictTask setValue:[NSNumber numberWithDouble:task.time] forKey:@"time"];
            
            [arrTasks addObject:dictTask];
        }
        
        [dictPractice setValue:arrTasks forKey:@"tasks"];
        
        [arrPractices addObject:dictPractice];
    }
    
    NSError *error = nil;
    //NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:arrPractices format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:arrPractices format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    
    return YES;
}

@end
