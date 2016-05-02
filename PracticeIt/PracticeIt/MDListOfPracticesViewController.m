//
//  MDListOfPracticesViewController.m
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDListOfPracticesViewController.h"
#import "MDAddPracticeViewController.h"
#import "MDPracticeTableViewCell.h"

@interface MDListOfPracticesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableOfPractices;


@end

@implementation MDListOfPracticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPracticePressed:(id)sender {
    
}

#pragma mark - TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDPracticeTableViewCell *cell = [self.tableOfPractices dequeueReusableCellWithIdentifier:@"practiceCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = @"Uma Prática";
    [cell.iconImageView setImage: [UIImage imageNamed:@"icon_clock"]];
    
    return cell;
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
