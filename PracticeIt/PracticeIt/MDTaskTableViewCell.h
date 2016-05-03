//
//  MDTaskTableViewCell.h
//  PracticeIt
//
//  Created by bepid on 5/3/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgress;

@property (weak, nonatomic) IBOutlet UITextField *ttsTextField;
@property (weak, nonatomic) IBOutlet UILabel *audioLabel;

@end
