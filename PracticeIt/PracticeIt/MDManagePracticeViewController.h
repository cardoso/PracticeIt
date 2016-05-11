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
#import "MDPracticeIt.h"
#import "SWTableViewCell.h"

@interface MDManagePracticeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, MDPracticeDelegate, AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) MDPracticeIt *practiceIt;
@property (weak, nonatomic) MDPractice *practice;
@property (weak, nonatomic) AVSpeechSynthesizer *synthesizer;

@end
