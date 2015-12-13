//
//  PersonalTaskDetailsViewController.m
//  Agendue
//
//  Created by Alec on 12/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "PersonalTaskDetailsViewController.h"

@interface PersonalTaskDetailsViewController ()
{
    Task *_task;
}
@end

@implementation PersonalTaskDetailsViewController

-(void) setTask:(id)task {
    _task = task;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:false animated:true];
    _taskTitle.text = _task.title;
    _taskDescription.text = _task.description;
    if (_task.duedate == nil) {
        _taskDueDate.text = @"No due date";
    } else {
        _taskDueDate.text = [_task duedate];
    }
    _taskLabel.backgroundColor = _task.label;
    if (_task.complete == YES) {
        _taskCompleted.text = @"Complete";
        _completeButton.title = @"Mark Incomplete";
    } else {
        _taskCompleted.text = @"Incomplete";
        _completeButton.title = @"Mark Complete";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)completeButtonPressed:(id)sender {
    if (_task.complete == YES)
    {
        _task.complete = NO;
        _taskCompleted.text = @"Incomplete";
        _completeButton.title = @"Mark Complete";
    }
    else
    {
        _task.complete = YES;
        _taskCompleted.text = @"Complete";
        _completeButton.title = @"Mark Incomplete";
    }
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        [iOSRequest saveEditedPersonalTask:_task.webID withName:_task.title description:_task.description completed:[_task stringComplete] duedate:_task.duedate label:[_task stringLabel] onCompletion:^(NSData *data, NSError *err) {
            //
        }];
    });
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"editPersonalTask"]) {
        [[segue destinationViewController] setTask:_task];
        
    }
}


- (IBAction)editButtonPressed:(id)sender {

}
@end
