//
//  MDAddPracticeViewController.h
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPracticeIt.h"

@interface MDAddPracticeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) MDPracticeIt *practiceIt;

@property BOOL isEditing;
@property NSInteger indexOfPracticeToEdit;

@property (strong, nonatomic) IBOutlet UIButton *cancelOutlet;
@property (strong, nonatomic) IBOutlet UIButton *saveOutlet;

@end
