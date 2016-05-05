//
//  MDManagePracticeViewController.m
//  
//
//  Created by bepid on 5/3/16.
//
//

#import "MDManagePracticeViewController.h"
#import "MDTaskTableViewCell.h"
#import "MDAddTaskViewController.h"

@interface MDManagePracticeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableOfTasks;
@property NSIndexPath *lastSelectedTaskIndexPath;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;

@end

@implementation MDManagePracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.practice.title;
    self.practice.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startPressed:(UIBarButtonItem *)sender {
    [self.practice start];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToAddTask"]){
        MDAddTaskViewController *controller = segue.destinationViewController;
        
        controller.practice = self.practice;
    }
}

#pragma mark TableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDTaskTableViewCell *cell = [self.tableOfTasks dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    MDTask *task = [self.practice taskAtIndex:indexPath.row];
    
    cell.delegate = self;
    cell.rightUtilityButtons = [self rightButtonsForTaskCell];
    
    cell.titleLabel.text = task.title;
    cell.currentTimeLabel.text = [MDPractice stringFromTimeInterval:task.currentTime];
    
    cell.timeLabel.text = [MDPractice stringFromTimeInterval:task.time];
    
    
    cell.ttsMessageLabel.text = task.ttsMessage;
    cell.audioLabel.text = task.audio;
    cell.timeProgress.progress = task.currentTime/task.time;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.practice.tasks.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [self.tableOfTasks indexPathForSelectedRow]) {
        return  160;
    }
    else return 76;

}

#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
    self.lastSelectedTaskIndexPath = indexPath;
}

#pragma  mark MDPracticeDelegate

-(void)onTaskAdded{
    [self.tableOfTasks reloadData];
}

-(void)onTaskRemoved{
    [self.tableOfTasks reloadData];
}

-(void)onTimerTick {
    MDTask *task = [self.practice currentTask];
    
    MDTaskTableViewCell *cell = [self.tableOfTasks cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.practice.currentTaskIndex inSection:0]];
    
    cell.currentTimeLabel.text = [MDPractice stringFromTimeInterval:task.currentTime];
    
    cell.timeLabel.text = [MDPractice stringFromTimeInterval:task.time];
    cell.timeProgress.progress = task.currentTime/task.time;
}

-(void)onTaskFinished {
    
}

-(void)onTaskStarted {
    
}

-(void)onPracticeStarted {
    [self.startButton setStyle:UIBarButtonSystemItemPause];
}

-(void)onPracticeFinished {
    
}

#pragma mark - SWTableViewCell

- (NSArray *)rightButtonsForTaskCell
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
    
    NSInteger row = [self.tableOfTasks indexPathForCell:cell].row;
    
    if(index == 0) {
        [self.practice removeTaskAtIndex:row];
    }
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
