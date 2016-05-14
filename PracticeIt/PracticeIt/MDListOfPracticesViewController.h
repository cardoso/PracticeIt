//
//  MDListOfPracticesViewController.h
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TableViewDragger-Swift.h"

#import "MDPracticeIt.h"
#import "MDPracticeTableViewCell.h"

@interface MDListOfPracticesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SWTableViewCellDelegate, MDPracticeItDelegate, TableViewDraggerDelegate, TableViewDraggerDataSource, UISplitViewControllerDelegate>

@property MDPracticeIt *practiceIt;

@end
