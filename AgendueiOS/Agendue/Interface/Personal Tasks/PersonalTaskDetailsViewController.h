//
//  PersonalTaskDetailsViewController.h
//  Agendue
//
//  Created by Alec on 12/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "iOSRequest.h"
#import "EditPersonalTaskViewController.h"

@interface PersonalTaskDetailsViewController : UIViewController
-(void) setTask: (Task *) task;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeButton;
@property (weak, nonatomic) IBOutlet UILabel *taskTitle;
@property (weak, nonatomic) IBOutlet UIView *taskLabel;
- (IBAction)editButtonPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *taskDueDate;
@property (weak, nonatomic) IBOutlet UILabel *taskCompleted;
@property (weak, nonatomic) IBOutlet UILabel *taskDescription;

@end
