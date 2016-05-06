//
//  MDAddTaskViewController.m
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDAddTaskViewController.h"

@interface MDAddTaskViewController ()

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttsMessageTextField;
@property (strong, nonatomic) IBOutlet UITextField *audioTextField;
@property (strong, nonatomic) IBOutlet UIDatePicker *timeDatePicker;

@end

@implementation MDAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.task) {
        self.titleTextField.text = self.task.title;
        self.ttsMessageTextField.text = self.task.ttsMessage;
        self.audioTextField.text = self.task.audio;
        [self.timeDatePicker setCountDownDuration:self.task.time];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(UIButton *)sender {
    
    if(self.practice) {
        [self.practice addTaskWithTitle:self.titleTextField.text WithTTSMessage:self.ttsMessageTextField.text WithAudio:self.audioTextField.text WithTime:self.timeDatePicker.countDownDuration];
    }
    else if(self.task) {
        self.task.title = self.titleTextField.text;
        self.task.ttsMessage = self.ttsMessageTextField.text;
        self.task.audio = self.audioTextField.text;
        self.task.time = self.timeDatePicker.countDownDuration;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
