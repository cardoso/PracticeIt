//
//  MDManagePracticeViewController.m
//  
//
//  Created by bepid on 5/3/16.
//
//

#import "MDManagePracticeViewController.h"
#import "MDTaskTableViewCell.h"

@interface MDManagePracticeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableOfTasks;
@property NSIndexPath *lastSelectedTaskIndexPath;

@end

@implementation MDManagePracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.practice.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDTaskTableViewCell *cell = [self.tableOfTasks dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.practice.tasks.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath == [self.tableOfTasks indexPathForSelectedRow]) {
        return  160;
    }
    else return 76;

}

#pragma mark TableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [((MDTaskTableViewCell*)[self.tableOfTasks cellForRowAtIndexPath:self.lastSelectedTaskIndexPath]).ttsTextField resignFirstResponder];
    
    [tableView beginUpdates];
    [tableView endUpdates];
    
    self.lastSelectedTaskIndexPath = indexPath;
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
