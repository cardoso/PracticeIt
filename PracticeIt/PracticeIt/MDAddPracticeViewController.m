//
//  MDAddPracticeViewController.m
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDAddPracticeViewController.h"
#import "UITextField+Shake.h"

@interface MDAddPracticeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;

@property NSArray *iconNames;
@property NSInteger selectedIconIndex;

@end

@implementation MDAddPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.iconNames = @[@"icon_clock",@"icon_audio", @"icon_tts"];
    
    // If is editing
    if(self.practice) {
        self.nameTextField.text = self.practice.title;
        self.descriptionTextView.text = self.practice.desc;
        [self.iconCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.iconNames indexOfObject:self.practice.iconName] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)savePressed:(UIButton *)sender {
    // TODO: Everything
    if([self.nameTextField.text isEqualToString:@""]) {
        [self.nameTextField shake];
    }
    else {
        if(self.practiceIt) {
            [self.practiceIt addPracticeWithTitle:self.nameTextField.text WithDescription:self.descriptionTextView.text WithIconName:[self.iconNames objectAtIndex:self.selectedIconIndex]];
        }
        else if(self.practice) {
            self.practice.title = self.nameTextField.text;
            self.practice.desc = self.descriptionTextView.text;
            self.practice.iconName = [self.iconNames objectAtIndex:self.selectedIconIndex];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)cancelPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark CollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconNames.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.iconCollectionView dequeueReusableCellWithReuseIdentifier:@"iconCell" forIndexPath:indexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame: cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
    
    ((UIImageView*)([cell viewWithTag:12])).image = [UIImage imageNamed:[self.iconNames objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark CollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIconIndex = indexPath.row;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
