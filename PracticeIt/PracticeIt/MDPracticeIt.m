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

-(NSInteger)practiceCount {
    return [self.practices count];
}

-(MDPractice *)practiceAtIndex:(NSInteger)index {
    if(index < 0 || index >= [self.practices count])
        return nil;
    
    return [self.practices objectAtIndex:index];
}

-(NSInteger)indexForPractice:(MDPractice *)practice {
    for(NSInteger i = 0; i < [self.practices count]; i++)
        if(self.practices[i] == practice)
            return i;
    
    return -1;
}

-(BOOL)removePracticeAtIndex:(NSInteger)index {
    if(index >= [self.practices count])
        return NO;
        
    MDPractice *practice = [self practiceAtIndex:index];
        
    if(![self.delegate practiceIt:self shouldRemovePractice:practice])
        return NO;
    
    [self.delegate practiceIt:self willRemovePractice:practice];
    [self.practices removeObjectAtIndex:index];
    
    [self saveData];
        
    return YES;
}

-(MDPractice*)addPracticeWithTitle:(NSString *)title withDescription:(NSString *)description withIconName:(NSString *)iconName {
    MDPractice *practice = [[MDPractice alloc] init];
    
    practice.title = title;
    practice.desc = description;
    practice.iconName = iconName;
    
    [self.practices addObject:practice];
    
    [self.delegate practiceIt:self didAddPractice:practice];
    
    return practice;
}

-(BOOL)editPracticeAtIndex:(NSInteger)index withNewTitle:(NSString *)newTitle withNewDescription:(NSString *)newDescription withNewIcon:(NSString *)newIconName {
    if(index < [self.practices count]) {
        MDPractice* practice = [self practiceAtIndex:index];
        
        practice.title = newTitle;
        practice.desc = newDescription;
        practice.iconName = newIconName;
        
        [self.delegate practiceIt:self didEditPractice:practice];
        
        return YES;
    }
    
    return NO;
}

-(BOOL)movePracticeAtIndex:(NSInteger)index toIndex:(NSInteger)targetIndex {
    
    if(index >= [self practiceCount] || index < 0 || targetIndex >= [self practiceCount] || index < 0)
        return NO;
    
    MDPractice *task = [self practiceAtIndex:index];
    
    [self.practices removeObject:task];
    [self.practices insertObject:task atIndex:targetIndex];
    
    return TRUE;
}

-(BOOL)loadData {
    BOOL result1 = [self loadPractices];
    BOOL result2 = [self loadUserProperties];
    
    return result1 && result2;
}

-(BOOL)saveData {
    BOOL result1 = [self savePractices];
    BOOL result2 = [self saveUserProperties];
    
    return result1 && result2;
}

-(BOOL)savePractices {
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
    
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:arrPractices format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    
    return YES;
}

-(BOOL)loadPractices {
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
        
        MDPractice *pract = [self addPracticeWithTitle:title withDescription:desc withIconName:iconName];
        
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
            
            MDTask *task = [[MDTask alloc] initWithTitle:title WithTTSMessage:ttsMessage WithAudio:audio WithTime:time.doubleValue];
            [pract.tasks addObject:task];
        }
        
    }
    
    return YES;
}

-(BOOL)loadUserProperties {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"plist"];
    }
    
    NSDictionary *userPropertiesDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    self.tutorialStep = ((NSNumber*)[userPropertiesDictionary objectForKey:@"tutorialStep"]).integerValue;
    
    return YES;
}

-(BOOL)saveUserProperties {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"user.plist"];
    
    NSMutableDictionary *userPropertiesDictionary = [NSMutableDictionary dictionary];
    
    [userPropertiesDictionary setObject:[NSNumber numberWithInteger:self.tutorialStep] forKey:@"tutorialStep"];
    
    NSError *error = nil;

    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:userPropertiesDictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    
    return YES;
}

@end
