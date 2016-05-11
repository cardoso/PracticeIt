//
//  MDAddPracticeViewController.h
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZFormSheetPresentationViewController.h"
#import "MDPracticeIt.h"

@interface MDAddPracticeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) MDPracticeIt *practiceIt;
@property (weak, nonatomic) MDPractice *practice;

@end
