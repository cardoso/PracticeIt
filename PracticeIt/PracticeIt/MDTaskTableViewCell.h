//
//  MDTaskTableViewCell.h
//  PracticeIt
//
//  Created by bepid on 5/3/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel/MarqueeLabel.h"
#import "SWTableViewCell.h"

// SWTableViewCell pod
@interface MDTaskTableViewCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet MarqueeLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet MarqueeLabel *ttsMessageLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *timeProgress;


@property (weak, nonatomic) IBOutlet MarqueeLabel *audioLabel;

@end
