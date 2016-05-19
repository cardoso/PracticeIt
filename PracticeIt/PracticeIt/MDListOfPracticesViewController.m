//
//  MDListOfPracticesViewController.m
//  PracticeIt
//
//  Created by bepid on 5/2/16.
//  Copyright © 2016 MatheusDaniel. All rights reserved.
//

#import "MZFormSheetPresentationViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"



#import "MDListOfPracticesViewController.h"
#import "MDAddPracticeViewController.h"
#import "MDManagePracticeViewController.h"

@interface MDListOfPracticesViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableOfPractices;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *AddBarButton;

@property (strong,nonatomic) MDAddPracticeViewController *AddView;
@property (weak, nonatomic) MDManagePracticeViewController *manageView;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (strong, nonatomic) TableViewDragger *dragger;

@property BOOL isDragging;

@end

@implementation MDListOfPracticesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.practiceIt = [[MDPracticeIt alloc] init];
    self.practiceIt.delegate = self;
    
    self.tableOfPractices.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    
    self.dragger = [[TableViewDragger alloc] initWithTableView:self.tableOfPractices];
    self.dragger.delegate = self;
    self.dragger.dataSource = self;
    
    self.splitViewController.delegate = self;
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    self.manageView = (MDManagePracticeViewController*)((UINavigationController*)self.splitViewController.viewControllers[1]).topViewController;
    self.manageView.practiceIt = self.practiceIt;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableOfPractices reloadData];
    [self.practiceIt saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"segueToAddPractice"]) {
        MZFormSheetPresentationViewControllerSegue *presentationSegue = (id)segue;
        
        presentationSegue.formSheetPresentationController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideAndBounceFromTop;
        
        presentationSegue.formSheetPresentationController.allowDismissByPanningPresentedView = YES;
        presentationSegue.formSheetPresentationController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionUp | MZFormSheetPanGestureDismissDirectionDown;
        
        presentationSegue.formSheetPresentationController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTop;
        
        MDAddPracticeViewController *controller = segue.destinationViewController;
        
        controller.practiceIt = self.practiceIt;
        
        if(sender && [sender isKindOfClass:NSClassFromString(@"NSNumber")]) {
            controller.isEditing = YES;
            controller.indexOfPracticeToEdit = [sender integerValue];
        }
    }
    
    if([segue.identifier isEqualToString:@"segueToManagePractice"]) {
        MDManagePracticeViewController *controller = segue.destinationViewController;
        
        MDPractice *practice = [self.practiceIt practiceAtIndex:((NSIndexPath*)sender).row];
        
        controller.practice = practice;
        controller.practiceIt = self.practiceIt;
        controller.synthesizer = self.synthesizer;
    }
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController
collapseSecondaryViewController:(UIViewController *)secondaryViewController
  ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]]
        && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MDManagePracticeViewController class]]
        && ([(MDManagePracticeViewController *)[(UINavigationController *)secondaryViewController topViewController] practice] == nil)) {
        
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
        
    } else {
        
        return NO;
        
    }
}

#pragma mark - TableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO
    return [self.practiceIt.practices count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDPractice *practice = [self.practiceIt practiceAtIndex:indexPath.row];
    
    MDPracticeTableViewCell *cell = [self.tableOfPractices dequeueReusableCellWithIdentifier:@"practiceCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.titleLabel.text = practice.title;
    [cell.iconImageView setImage: [UIImage imageNamed:practice.iconName]];
    cell.rightUtilityButtons = [self rightButtonsForPracticeCell];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:178.0/255 green:215.0/255 blue:1.0 alpha:0.5];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

#pragma mark - MDPracticeItDelegate

-(void)practiceIt:(id)practiceIt didAddPractice:(MDPractice *)practice {
    [self.tableOfPractices beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.practiceIt indexForPractice:practice] inSection:0];
    [self.tableOfPractices insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableOfPractices endUpdates];
    [self.practiceIt saveData];
}

-(BOOL)practiceIt:(id)practiceIt shouldRemovePractice:(MDPractice *)practice {
    return YES;
}

-(void)practiceIt:(id)practiceIt willRemovePractice:(MDPractice *)practice {
    [self.practiceIt saveData];
    
    if(practice == self.manageView.practice) {
        [self.manageView loadPractice:nil];
    }
}

-(void)practiceIt:(id)practiceIt didEditPractice:(MDPractice *)practice {
    [self.tableOfPractices beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.practiceIt indexForPractice:practice] inSection:0];
    [self.tableOfPractices reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableOfPractices endUpdates];
    [self.practiceIt saveData];
}

#pragma mark - TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self performSegueWithIdentifier:@"segueToManagePractice" sender:indexPath];
    self.manageView.synthesizer = self.synthesizer;
    [self.manageView loadViewIfNeeded];
    [self.manageView loadPractice:[self.practiceIt practiceAtIndex:indexPath.row]];
    [self.splitViewController showDetailViewController:self.manageView.navigationController sender:self];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.manageView loadPractice:nil];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}



#pragma mark - TableViewDraggerDelegate

-(BOOL)dragger:(TableViewDragger *)dragger moveDraggingAtIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableOfPractices moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self.practiceIt movePracticeAtIndex:indexPath.row toIndex:newIndexPath.row];
    [self.practiceIt saveData];
    return YES;
}

-(void)dragger:(TableViewDragger *)dragger willBeginDraggingAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableOfPractices selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableOfPractices beginUpdates];
    [self.tableOfPractices endUpdates];
    
    self.isDragging = YES;
}

-(void)dragger:(TableViewDragger *)dragger willEndDraggingAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableOfPractices beginUpdates];
    [self.tableOfPractices endUpdates];
}

-(void)dragger:(TableViewDragger *)dragger didEndDraggingAtIndexPath:(NSIndexPath *)indexPath {
    self.isDragging = NO;
    
    //color bug workaround
    SWTableViewCell *cell = [self.tableOfPractices cellForRowAtIndexPath:indexPath];
    [self.tableOfPractices reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableOfPractices selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 160);
    
    [UIView setAnimationsEnabled:NO];
    [self.tableOfPractices beginUpdates];
    [self.tableOfPractices endUpdates];
    [UIView setAnimationsEnabled:YES];
    
}

-(BOOL)dragger:(TableViewDragger *)dragger shouldDragAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - SWTableViewCell

- (NSArray *)rightButtonsForPracticeCell
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

-(BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tableOfPractices indexPathForCell:cell];
    
    if(index == 0) {
        [cell hideUtilityButtonsAnimated:YES];
        [self performSegueWithIdentifier:@"segueToAddPractice" sender:[NSNumber numberWithLong:indexPath.row]];
    }
    else if(index == 1) {
        [self.tableOfPractices beginUpdates];
        if([self.practiceIt removePracticeAtIndex:indexPath.row]){
            [self.tableOfPractices deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        [self.tableOfPractices endUpdates];
    }
}

//#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//}

@end
