//
//  MDManagePracticeViewController.h
//  
//
//  Created by bepid on 5/3/16.
//
//

#import <UIKit/UIKit.h>
#import "MDPractice.h"

@interface MDManagePracticeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) MDPractice *practice;

@end
