//
//  MDAddPracticeViewController.m
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "UITextField+Shake.h"

#import "MDAddPracticeViewController.h"

@interface MDAddPracticeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *iconCollectionView;

@property NSArray *iconNames;
@property NSInteger selectedIconIndex;

@property BOOL isEditingPracticeLoaded;

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
    
    self.cancelOutlet.layer.cornerRadius = 5;
    self.saveOutlet.layer.cornerRadius = 5;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"icons.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"icons" ofType:@"plist"];
    }
    
    self.iconNames = [NSArray arrayWithContentsOfFile:plistPath];
    
    self.nameTextField.delegate = self;
    self.descriptionTextView.delegate = self;
    
    [self.nameTextField becomeFirstResponder];
}

-(void)viewDidLayoutSubviews {
    if(self.isEditing && !self.isEditingPracticeLoaded) {
        MDPractice* practice = [self.practiceIt practiceAtIndex:self.indexOfPracticeToEdit];
        
        self.nameTextField.text = practice.title;
        self.descriptionTextView.text = practice.desc;
        
        for(NSInteger i = 0; i < self.iconNames.count; i++) {
            NSString *iconName = [self.iconNames objectAtIndex:i];
            
            if([practice.iconName isEqualToString:iconName]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.iconCollectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
                
                self.selectedIconIndex = i;
            }
        }
        
        self.isEditingPracticeLoaded = YES;
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
        if(!self.isEditing) {
            [self.practiceIt addPracticeWithTitle:self.nameTextField.text withDescription:self.descriptionTextView.text withIconName:[self.iconNames objectAtIndex:self.selectedIconIndex]];
        }
        else {
            [self.practiceIt editPracticeAtIndex:self.indexOfPracticeToEdit withNewTitle:self.nameTextField.text withNewDescription:self.descriptionTextView.text withNewIcon:[self.iconNames objectAtIndex:self.selectedIconIndex]];
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
    
    if(self.selectedIconIndex == indexPath.row)
        cell.layer.borderWidth = 2;
    else
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
