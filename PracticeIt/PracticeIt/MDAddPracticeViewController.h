//
//  MDAddPracticeViewController.h
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDPracticeIt.h"

@interface MDAddPracticeViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) MDPracticeIt *practiceIt;

@end
