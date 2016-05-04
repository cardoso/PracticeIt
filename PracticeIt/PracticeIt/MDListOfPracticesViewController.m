//
//  MDListOfPracticesViewController.m
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MDListOfPracticesViewController.h"
#import "MDAddPracticeViewController.h"
#import "MDManagePracticeViewController.h"

@interface MDListOfPracticesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableOfPractices;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AddBarButton;

@end

@implementation MDListOfPracticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.practiceIt = [[MDPracticeIt alloc] init];
    self.practiceIt.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segueToAddPractice"]) {
        MDAddPracticeViewController *controller = segue.destinationViewController;
    
        controller.practiceIt = self.practiceIt;
    }
    
    if([segue.identifier isEqualToString:@"segueToManagePractice"]) {
        MDManagePracticeViewController *controller = segue.destinationViewController;
        
        MDPractice *practice = [self.practiceIt getPracticeAtIndex:((NSIndexPath*)sender).row];
        
        controller.practice = practice;
    }
}

/*- (IBAction)addPracticePressed:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MDAddPracticeViewController *AddViewController = [storyboard instantiateViewControllerWithIdentifier:@"Pop"];
    
    // present the controller
    // on iPad, this will be a Popover
    // on iPhone, this will be an action sheet
    AddViewController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:AddViewController animated:YES completion:nil];
    
    // configure the Popover presentation controller
    UIPopoverPresentationController *popController = [AddViewController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.AddBarButton;
    popController.delegate = self;
}*/

#pragma mark - TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO
    return [self.practiceIt.practices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDPractice *practice = [self.practiceIt getPracticeAtIndex:indexPath.row];
    
    MDPracticeTableViewCell *cell = [self.tableOfPractices dequeueReusableCellWithIdentifier:@"practiceCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.titleLabel.text = practice.title;
    [cell.iconImageView setImage: [UIImage imageNamed:practice.iconName]];
    cell.rightUtilityButtons = [self rightButtonsForPracticeCell];
    
    return cell;
}

#pragma mark - MDPracticeItDelegate

-(void)onPracticeAdded {
    [self.tableOfPractices reloadData];
}

-(void)onPracticeRemoved {
    [self.tableOfPractices reloadData];
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueToManagePractice" sender:indexPath];
}

#pragma mark - SWTableViewCell

- (NSArray *)rightButtonsForPracticeCell
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    /*[rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Share"];*/
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSInteger row = [self.tableOfPractices indexPathForCell:cell].row;
    
    if(index == 0) {
        [self.practiceIt removePracticeAtIndex:row];
    }
}

//#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}

@end
