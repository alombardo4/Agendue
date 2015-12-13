//
//  TaskDetailsViewController.m
//  Agendue
//
//  Created by Alec on 8/12/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "TaskDetailsViewController.h"

@interface TaskDetailsViewController ()

@end

@implementation TaskDetailsViewController
{
    Task *_task;
    NSString *_webID;
    NSString *tname, *tdescription, *tduedate, *tassignedto;
    bool completedValue;
}

- (void)setTask:(Task *)task andWebID: (NSString *) webID
{
    _webID = [NSString stringWithFormat:@"%@", webID];
    _task = task;
}

- (IBAction)completionButtonPressed:(id)sender {
    NSString *writeComplete = @"0";
    if (completedValue == YES) {
        completedValue = NO;
        complete.text = @"Incomplete";
        completionButton.title = @"Mark Complete";
        writeComplete = @"0";
        
    } else {
        complete.text = @"Complete";
        completionButton.title = @"Mark Incomplete";
        writeComplete = @"1";
        completedValue = YES;
    }
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_async(main_queue, ^{
        [iOSRequest completeOrIncompleteTask:_task.webID completed:writeComplete onCompletion:^(NSData *data, NSError *err) {
            //
        }];
    });
}

- (IBAction)deleteTask:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteAlert show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1 ] animated:true];
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            
            [iOSRequest deleteTask:_task.webID onCompletion:^(NSData *data, NSError *error) {
            }];
        });
    }
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [scrollView setScrollEnabled:YES];
    [self.navigationController setToolbarHidden:false animated:true];
    [self.navigationController setToolbarHidden:false];


    if (![_task.name isKindOfClass:[NSNull class]])
    {
        [name setText:_task.name];
    }
    if (![_task.description isKindOfClass:[NSNull class]])
    {
        [description setText:_task.description];
        
    } else {
        [description setText:@""];
    }
    if (![_task.duedate isKindOfClass:[NSNull class]] && _task.duedate != nil)
    {
        [duedate setText: _task.duedate];
    } else {
        [duedate setText:@"None"];
    }
    if (![_task.assignedto isKindOfClass:[NSNull class]])
    {
        [assignedto setText: _task.assignedto];
        if ([_task.assignedto compare:@""] == 0) {
            [assignedto setText:@"None"];
        }
    } else {
        [assignedto setText:@"None"];
    }
    if (_task.complete == YES) {
        [complete setText:@"Complete"];
        completionButton.title = @"Mark Incomplete";
        completedValue = YES;
        if (_task.datecomplete != nil && ![_task.datecomplete isEqualToString:@"null"]) {
            datecomplete.text = _task.datecomplete;

            [scrollView setContentSize:CGSizeMake(320, 440)];

        } else {
            [scrollView setContentSize:CGSizeMake(320, 300)];
            datecompleteLabel.text = @"";
            [dateCompleteLine setBackgroundColor:[UIColor whiteColor]];
            [self.view setNeedsLayout];
        }
        


    }
    else {
        completedValue = NO;
        [complete setText:@"Incomplete"];
        [scrollView setContentSize:CGSizeMake(320, 300)];
        datecompleteLabel.text = @"";
        [dateCompleteLine setBackgroundColor:[UIColor whiteColor]];
        [self.view setNeedsLayout];
    }
    if (![_task.label isKindOfClass:[NSNull class]])
    {
        [self.label setBackgroundColor:_task.label];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editTask"]) {
        [[segue destinationViewController] setTask:_task AndWebID: _webID];

    }
}

@end
