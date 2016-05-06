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


@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;

@property (strong, nonatomic) UIBarButtonItem *pauseButton;

@end

@implementation MDManagePracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.practice.title;
    self.practice.delegate = self;
    
    // Create pause button
    self.pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePressed:)];
    [self setToolBarPaused];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableOfTasks reloadData];
    [self.practiceIt saveData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)startPressed:(UIBarButtonItem *)sender {
    [self setToolBarStarted];
    
    if(self.practice.isPaused)
        [self.practice resume];
    else
        [self.practice start];
}
- (void)pausePressed:(UIBarButtonItem *)sender {
    [self setToolBarPaused];
    
    [self.practice pause];
}

- (IBAction)nextPressed:(id)sender {
    [self.practice nextTask];
}
- (IBAction)previousPressed:(id)sender {
    [self.practice previousTask];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"segueToAddTask"]){
        MDAddTaskViewController *controller = segue.destinationViewController;
        
        if(sender && [sender isKindOfClass:NSClassFromString(@"NSNumber")])
            controller.task = [self.practice taskAtIndex:[sender longValue]];
        else
            controller.practice = self.practice;
    }
}

-(void)setToolBarPaused {
    NSMutableArray *aux = [self.toolbar.items mutableCopy];
    [aux replaceObjectAtIndex:3 withObject:self.startButton];
    
    [self.toolbar setItems:aux animated:YES];
}

-(void)setToolBarStarted {
    NSMutableArray *aux = [self.toolbar.items mutableCopy];
    [aux replaceObjectAtIndex:3 withObject:self.pauseButton];
    
    [self.toolbar setItems:aux animated:YES];
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
    if ([indexPath isEqual:[self.tableOfTasks indexPathForSelectedRow]]) {
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
    [self.practiceIt saveData];
}

-(void)onTaskRemoved{
    [self.tableOfTasks reloadData];
    [self.practiceIt saveData];
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
    /*NSLog(@"%@",self.actionsToolbar.items);
    UIBarButtonItem *pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:nil action:nil];*/
    
    /*self.actionsToolbar.items = pause;
    [[self.actionsToolbar setItems:[[self.actionsToolbar.items mutableCopy] replaceObjectAtIndex:3 withObject:pause]] ];
    NSMutableArray *placeholder = [[NSMutableArray alloc] init];
    placeholder = [self.actionsToolbar.items mutableCopy];
    [placeholder replaceObjectAtIndex:3 withObject:pause];
    self.actionsToolbar.items = placeholder;*/
    
}

-(void)onPracticeFinished {
    [self setToolBarPaused];
    [self.practice reset];
    [self.tableOfTasks reloadData];
}

#pragma mark - SWTableViewCell

- (NSArray *)rightButtonsForTaskCell
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
    
    NSInteger row = [self.tableOfTasks indexPathForCell:cell].row;
    
    if(index == 0) {
        [self performSegueWithIdentifier:@"segueToAddTask" sender:[NSNumber numberWithLong:row]];
    }
    if(index == 1) {
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
