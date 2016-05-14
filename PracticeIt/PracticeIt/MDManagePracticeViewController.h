//
//  MDManagePracticeViewController.h
//  
//
//  Created by bepid on 5/3/16.
//
//

@import AVFoundation;

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "SWTableViewCell.h"
#import "TableViewDragger-Swift.h"

#import "MDPracticeIt.h"

@interface MDManagePracticeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, MDPracticeDelegate, AVSpeechSynthesizerDelegate, TableViewDraggerDelegate, TableViewDraggerDataSource>

@property (weak, nonatomic) MDPracticeIt *practiceIt;
@property (weak, nonatomic) MDPractice *practice;
@property (weak, nonatomic) AVSpeechSynthesizer *synthesizer;

-(void)loadPractice:(MDPractice*)practice;

@end
