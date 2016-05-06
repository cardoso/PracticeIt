//
//  MDManagePracticeViewController.h
//  
//
//  Created by bepid on 5/3/16.
//
//

#import <UIKit/UIKit.h>
#import "MDPracticeIt.h"
#import "SWTableViewCell.h"

@interface MDManagePracticeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, MDPracticeDelegate>

@property (weak, nonatomic) MDPracticeIt *practiceIt;
@property (weak, nonatomic) MDPractice *practice;

@end
