//
//  MDAddTaskViewController.h
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "MDPractice.h"

@interface MDAddTaskViewController : UIViewController <MPMediaPickerControllerDelegate, UITextFieldDelegate>

@property (weak,nonatomic) MDPractice *practice;
@property BOOL isEditing;
@property NSInteger indexOfTaskToEdit;

@property (strong, nonatomic) IBOutlet UIButton *cancelOutlet;
@property (strong, nonatomic) IBOutlet UIButton *saveOutlet;

@end
