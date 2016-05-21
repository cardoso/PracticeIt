//
//  MDAddTaskViewController.m
//  PracticeIt
//
//  Created by bepid on 5/5/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "UITextField+Shake.h"

#import "MDAddTaskViewController.h"

#import "MDTimeIntervalPickerView.h"

#import "MDMediaPickerController.h"

#import "MarqueeLabel/MarqueeLabel.h"

@interface MDAddTaskViewController ()

@property (strong, nonatomic) IBOutlet UITextField *titleTextField;
@property (strong, nonatomic) IBOutlet UITextField *ttsMessageTextField;
@property (strong, nonatomic) IBOutlet MarqueeLabel *audioLabel;
@property (strong, nonatomic) IBOutlet MDTimeIntervalPickerView *timeIntervalPicker;
@property (strong, nonatomic) IBOutlet UIButton *removeAudioButton;

@property MDMediaPickerController *audioPicker;
@property MPMediaItem *pickedAudio;

@property BOOL isEditingTaskLoaded;

@end

@implementation MDAddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.audioPicker = [[MDMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    self.audioPicker.delegate = self;
    
    self.titleTextField.delegate = self;
    self.ttsMessageTextField.delegate = self;
    
    [self.titleTextField becomeFirstResponder];
    
    [self.timeIntervalPicker setTimeInterval:60 animated:NO];
    
    self.cancelOutlet.layer.cornerRadius = 5;
    self.saveOutlet.layer.cornerRadius = 5;
    
    self.removeAudioButton.hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    if(self.isEditing && !self.isEditingTaskLoaded) {
        MDTask *task = [self.practice taskAtIndex:self.indexOfTaskToEdit];
        
        self.titleTextField.text = task.title;
        self.ttsMessageTextField.text = task.ttsMessage;
        [self.timeIntervalPicker setTimeInterval:task.time animated:NO];
        
        if(task.audio) {
            self.audioLabel.text = task.audio.title;
            self.pickedAudio = task.audio;
            self.removeAudioButton.hidden = NO;
        }
        else
            self.audioLabel.text = @"No audio";
        
        self.isEditingTaskLoaded = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [self.audioLabel triggerScrollStart];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.titleTextField resignFirstResponder];
    [self.ttsMessageTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAudioPressed:(UIButton *)sender {
    [self presentViewController:self.audioPicker animated:YES completion:nil];
}

- (IBAction)removeAudioPressed:(UIButton *)sender {
    if(self.pickedAudio) {
        self.pickedAudio = nil;
        self.removeAudioButton.hidden = YES;
        self.audioLabel.text = @"No audio";
    }
}

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    self.pickedAudio = [[mediaItemCollection items] objectAtIndex:0];
    self.audioLabel.text = self.pickedAudio.title;
    [self.audioPicker dismissViewControllerAnimated:YES completion:nil];
    
    self.removeAudioButton.hidden = NO;
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    [self.audioPicker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)savePressed:(UIButton *)sender {
    
    if([self.titleTextField.text isEqualToString:@""]) {
        [self.titleTextField shake];
    }
    else {
        
        if(!self.isEditing) {
            [self.practice addTaskWithTitle:self.titleTextField.text withTtsMessage:self.ttsMessageTextField.text withAudio:self.pickedAudio withTime:[self.timeIntervalPicker timeInterval]];
        }
        else {
            [self.practice editTaskAtIndex:self.indexOfTaskToEdit withNewTitle:self.titleTextField.text withNewTtsMessage:self.ttsMessageTextField.text withNewAudio:self.pickedAudio withNewTime:[self.timeIntervalPicker timeInterval]];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.titleTextField) {
        [self.titleTextField resignFirstResponder];
        [self.ttsMessageTextField becomeFirstResponder];
    }
    
    if(textField == self.ttsMessageTextField) {
        [self.ttsMessageTextField resignFirstResponder];
    }
    
    return NO;
}


@end
