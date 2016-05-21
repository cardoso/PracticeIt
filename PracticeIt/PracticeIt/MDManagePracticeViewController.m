//
//  MDManagePracticeViewController.m
//  
//
//  Created by bepid on 5/3/16.
//
//

#import "MZFormSheetPresentationViewController.h"
#import "MZFormSheetPresentationViewControllerSegue.h"

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

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@property TableViewDragger *dragger;
@property BOOL isDragging;

@end

@implementation MDManagePracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableOfTasks.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.synthesizer.delegate = self;
    
    // Dragger
    self.dragger = [[TableViewDragger alloc] initWithTableView:self.tableOfTasks];
    self.dragger.delegate = self;
    self.dragger.dataSource = self;
    self.dragger.cellAlpha = 0.7;
    
    // Create pause button
    self.pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pausePressed:)];
    [self setToolBarPaused];
    
    // Load empty practice
    [self loadPractice:nil];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableOfTasks reloadData];
    [self.practiceIt saveData];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.practice pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadPractice:(MDPractice *)practice {
    if(practice) {
        self.practice = practice;
        self.title = self.practice.title;
        self.practice.delegate = self;
    
        [self setToolBarPaused];
        [self.practice reset];
    
        [self.tableOfTasks reloadData];
        
        if([self.practice taskCount] > 0)
            [self setStartPauseEnabled:YES];
        else [self setStartPauseEnabled:NO];
        
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    else {
        self.practice = nil;
        self.title = @"Select a Practice";
        [self.tableOfTasks reloadData];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        [self setStartPauseEnabled:NO];
    }
}

- (IBAction)startPressed:(UIBarButtonItem *)sender {
    if([self.practice taskCount] > 0) {
        [self setToolBarStarted];
        [self setStartPauseEnabled:YES];
        
        if([self.practice isPaused])
            [self.practice resume];
        else
            [self.practice start];
    }
}
- (void)pausePressed:(UIBarButtonItem *)sender {
    [self setToolBarPaused];
    [self setStartPauseEnabled:YES];
    
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
        MZFormSheetPresentationViewControllerSegue *presentationSegue = (id)segue;
        
        presentationSegue.formSheetPresentationController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleSlideAndBounceFromTop;
        
        presentationSegue.formSheetPresentationController.allowDismissByPanningPresentedView = YES;
        presentationSegue.formSheetPresentationController.interactivePanGestureDismissalDirection = MZFormSheetPanGestureDismissDirectionUp | MZFormSheetPanGestureDismissDirectionDown;
        
        presentationSegue.formSheetPresentationController.presentationController.movementActionWhenKeyboardAppears = MZFormSheetActionWhenKeyboardAppearsMoveToTop;
        
        MDAddTaskViewController *controller = segue.destinationViewController;
        
        controller.practice = self.practice;
        
        if(sender && [sender isKindOfClass:NSClassFromString(@"NSNumber")]) {
            controller.indexOfTaskToEdit = [sender integerValue];
            controller.isEditing = YES;
        }
            
    }
}

-(void)setToolBarPaused {
    NSMutableArray *aux = [self.toolbar.items mutableCopy];
    [aux replaceObjectAtIndex:3 withObject:self.startButton];
    
    self.previousButton.enabled = NO;
    self.nextButton.enabled = NO;
    
    [self.toolbar setItems:aux animated:YES];
}

-(void)setToolBarStarted {
    NSMutableArray *aux = [self.toolbar.items mutableCopy];
    [aux replaceObjectAtIndex:3 withObject:self.pauseButton];
    
    self.previousButton.enabled = YES;
    self.nextButton.enabled = YES;
    
    [self.toolbar setItems:aux animated:YES];
}

-(void)setStartPauseEnabled:(BOOL)enabled {
    self.startButton.enabled = enabled;
    self.pauseButton.enabled = enabled;
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
    
    
    cell.ttsMessageLabel.text = ![task.ttsMessage isEqualToString:@""] ? task.ttsMessage : @"No message";
    cell.audioLabel.text = task.audio.title ? task.audio.title : @"No audio";
    cell.timeProgress.progress = task.currentTime/task.time;
    
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:178.0/255 green:215.0/255 blue:1.0 alpha:0.5];
    [cell setSelectedBackgroundView:bgColorView];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.practice.tasks.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath isEqual:[self.tableOfTasks indexPathForSelectedRow]]) {
        return  160;
    }
    else return 84;

}

#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView beginUpdates];
    [tableView endUpdates];
    
    if(![self.practice isPaused] && ![self.practice isStopped])
        [self.practice startTaskAtIndex:indexPath.row];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath;
}

#pragma mark - TableViewDraggerDelegate

-(BOOL)dragger:(TableViewDragger *)dragger moveDraggingAtIndexPath:(NSIndexPath *)indexPath newIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableOfTasks moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
    [self.practice moveTaskAtIndex:indexPath.row toIndex:newIndexPath.row];
    [self.practiceIt saveData];
    return YES;
}

-(void)dragger:(TableViewDragger *)dragger willBeginDraggingAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableOfTasks selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self.tableOfTasks beginUpdates];
    [self.tableOfTasks endUpdates];
    
    self.isDragging = YES;
}

-(void)dragger:(TableViewDragger *)dragger willEndDraggingAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableOfTasks beginUpdates];
    [self.tableOfTasks endUpdates];
}

-(void)dragger:(TableViewDragger *)dragger didEndDraggingAtIndexPath:(NSIndexPath *)indexPath {
    self.isDragging = NO;
    
    //color bug workaround
    SWTableViewCell *cell = [self.tableOfTasks cellForRowAtIndexPath:indexPath];
    [self.tableOfTasks reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableOfTasks selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 160);
    
    [UIView setAnimationsEnabled:NO];
    [self.tableOfTasks beginUpdates];
    [self.tableOfTasks endUpdates];
    [UIView setAnimationsEnabled:YES];
    
}

-(BOOL)dragger:(TableViewDragger *)dragger shouldDragAtIndexPath:(NSIndexPath *)indexPath {
    return [self.practice isPaused] || [self.practice isStopped];
}

#pragma mark MDPracticeDelegate

-(void)didPausePractice:(id)practice {

    [self.audioPlayer pause];
    
    [self.synthesizer pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

-(void)didResumePractice:(id)practice {
    [self.audioPlayer play];
    [self.synthesizer continueSpeaking];
}

-(BOOL)practice:(MDPractice*)practice shouldAddTask:(MDTask *)task {
    return YES;
}

-(void)practice:(MDPractice*)practice didAddTask:(MDTask *)task {
    [self.tableOfTasks beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.practice indexForTask:task] inSection:0];
    [self.tableOfTasks insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableOfTasks endUpdates];
    [self.practiceIt saveData];
    
    if([self.practice taskCount] == 1)
        [self setStartPauseEnabled:YES];
}

-(void)practice:(id)practice didEditTask:(MDTask *)task {
    [self.tableOfTasks beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.practice indexForTask:task] inSection:0];
    [self.tableOfTasks reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableOfTasks endUpdates];
    
    [self.practiceIt saveData];
}

-(BOOL)practice:(MDPractice*)practice shouldRemoveTask:(MDTask *)task {
    return YES;
}

-(void)practice:(MDPractice*)practice willRemoveTask:(MDTask *)task {
    [self.practice previousTask];
    
    if([self.practice taskCount] == 1)
        [self setStartPauseEnabled:NO];
}

-(void)practice:(id)practice didRemoveTask:(MDTask *)task {
    [self.practiceIt saveData];
}

-(void)didTimerTickOnPractice:(MDPractice*)practice {
    MDTask *task = [self.practice currentTask];
    
    MDTaskTableViewCell *cell = [self.tableOfTasks cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.practice.currentTaskIndex inSection:0]];
    
    cell.currentTimeLabel.text = [MDPractice stringFromTimeInterval:task.currentTime];
    
    cell.timeLabel.text = [MDPractice stringFromTimeInterval:task.time];
    cell.timeProgress.progress = task.currentTime/task.time;
}

-(void)practice:(id)practice didStartTask:(MDTask *)task {
    [self.tableOfTasks selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.practice indexForTask:task] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    [self.tableOfTasks beginUpdates];
    [self.tableOfTasks endUpdates];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:task.ttsMessage];
    [utterance setRate:AVSpeechUtteranceDefaultSpeechRate];
    
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    [self.synthesizer speakUtterance:utterance];
    
    if(task.audio) {
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[task.audio valueForProperty:MPMediaItemPropertyAssetURL] error: nil];
    }
    else {
        self.audioPlayer = nil;
    }

    
}

-(void)practice:(id)practice willFinishTask:(MDTask *)task {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

-(void)didStartPractice:(MDPractice*)practice {
    /*NSLog(@"%@",self.actionsToolbar.items);
    UIBarButtonItem *pause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:nil action:nil];*/
    
    /*self.actionsToolbar.items = pause;
    [[self.actionsToolbar setItems:[[self.actionsToolbar.items mutableCopy] replaceObjectAtIndex:3 withObject:pause]] ];
    NSMutableArray *placeholder = [[NSMutableArray alloc] init];
    placeholder = [self.actionsToolbar.items mutableCopy];
    [placeholder replaceObjectAtIndex:3 withObject:pause];
    self.actionsToolbar.items = placeholder;*/
}

-(void)didFinishPractice:(MDPractice*)practice {
    [self setToolBarPaused];
    [self.practice reset];
    [self.tableOfTasks reloadData];
}

#pragma mark - AVSpeechSyntesizerDelegate

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self.audioPlayer play];
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

-(BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state {
    return ([self.practice isPaused] || [self.practice isStopped]) && !self.isDragging;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
    NSIndexPath *indexPath = [self.tableOfTasks indexPathForCell:cell];
    
    if(index == 0) {
        [cell hideUtilityButtonsAnimated:YES];
        [self performSegueWithIdentifier:@"segueToAddTask" sender:[NSNumber numberWithLong:indexPath.row]];
    }
    if(index == 1) {
        [self.tableOfTasks beginUpdates];
        if([self.practice removeTaskAtIndex:indexPath.row]) {
            [self.tableOfTasks deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }
        [self.tableOfTasks endUpdates];
    }
}

@end
