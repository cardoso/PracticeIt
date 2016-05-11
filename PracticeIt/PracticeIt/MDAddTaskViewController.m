//
//  MDAddTaskViewController.m
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDAddTaskViewController.h"
#import "UITextField+Shake.h"

@interface MDAddTaskViewController ()

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttsMessageTextField;
@property (strong, nonatomic) IBOutlet UILabel *audioLabel;
@property (strong, nonatomic) IBOutlet UIDatePicker *timeDatePicker;

@property MPMediaPickerController *audioPicker;
@property MPMediaItem *pickedAudio;

@end

@implementation MDAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.audioPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    self.audioPicker.delegate = self;
    
    self.titleTextField.delegate = self;
    self.ttsMessageTextField.delegate = self;
    
    if(self.task) {
        self.titleTextField.text = self.task.title;
        self.ttsMessageTextField.text = self.task.ttsMessage;
        self.audioLabel.text = self.task.audio.title;
        [self.timeDatePicker setCountDownDuration:self.task.time];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [self.titleTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAudioPressed:(UIButton *)sender {
    [self presentViewController:self.audioPicker animated:YES completion:nil];
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    self.pickedAudio = [[mediaItemCollection items] objectAtIndex:0];
    self.audioLabel.text = self.pickedAudio.title;
    [self.audioPicker dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self.audioPicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(UIButton *)sender {
    
    if([self.titleTextField.text isEqualToString:@""]) {
        [self.titleTextField shake];
    }
    else {
        if(self.practice) {
            [self.practice addTaskWithTitle:self.titleTextField.text WithTTSMessage:self.ttsMessageTextField.text WithAudio:self.pickedAudio WithTime:self.timeDatePicker.countDownDuration];
        }
        else if(self.task) {
            self.task.title = self.titleTextField.text;
            self.task.ttsMessage = self.ttsMessageTextField.text;
            self.task.audio = self.pickedAudio;
            self.task.time = self.timeDatePicker.countDownDuration;
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.titleTextField) {
        [self.titleTextField resignFirstResponder];
        [self.ttsMessageTextField becomeFirstResponder];
    }
    
    if(textField == self.ttsMessageTextField) {
        [self.ttsMessageTextField resignFirstResponder];
    }
    
    return YES;
}


@end
