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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePressed:(UIButton *)sender {
    [self.practice addTaskWithTitle:self.titleTextField.text WithTTSMessage:self.ttsMessageTextField.text WithAudio:self.audioTextField.text WithTime:self.timeDatePicker.countDownDuration];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
