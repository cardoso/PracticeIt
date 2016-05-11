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
    
    self.descriptionTextView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.borderWidth = 0.5;
    
    self.iconCollectionView.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0].CGColor;
    self.iconCollectionView.layer.cornerRadius = 5;
    self.iconCollectionView.layer.borderWidth = 0.5;
    
    self.iconNames = @[@"icon_clock",@"adhesive-tape",@"archive",@"bar-chart",@"briefcase-1",@"briefcase",@"cabinet",@"cactus",@"calculator",@"circular-chart",@"coffee",@"contract-1",@"contract",@"cutter",@"desk",@"diskette",@"email",@"envelope-1",@"envelope",@"exchange",@"fax",@"file",@"idea",@"lamp"];
    
    self.nameTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    [self.nameTextField becomeFirstResponder];

}

-(void)viewWillAppear:(BOOL)animated {
    if(self.practice) {
        self.nameTextField.text = self.practice.title;
        self.descriptionTextView.text = self.practice.desc;
        [self.iconCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[self.iconNames indexOfObject:self.practice.iconName] inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.nameTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
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
    
    ((UIImageView*)([cell viewWithTag:12])).image = [UIImage imageNamed:[self.iconNames objectAtIndex:indexPath.row]];
    cell.layer.borderColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:1 alpha:1.0].CGColor;
    cell.layer.cornerRadius = 5;
    cell.layer.borderWidth = 0;
    
    return cell;
}

#pragma mark CollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *oldSelectedCell = [self.iconCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIconIndex inSection:0]];
    UICollectionViewCell *selectedCell = [self.iconCollectionView cellForItemAtIndexPath:indexPath];
    
    oldSelectedCell.layer.borderWidth = 0;
    selectedCell.layer.borderWidth = 2;
    
    self.selectedIconIndex = indexPath.row;
}

#pragma mark TextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.descriptionTextView becomeFirstResponder];
    return YES;
}

#pragma mark TextViewDelegate

-(void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
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
