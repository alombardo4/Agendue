//
//  TaskDetailsViewController.h
//  Agendue
//
//  Created by Alec on 8/12/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Task.h"
#import "EditTaskViewController.h"
@interface TaskDetailsViewController :  UIViewController<UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *description;
    __weak IBOutlet UILabel *duedate;
    __weak IBOutlet UILabel *complete;
    __weak IBOutlet UILabel *assignedto;
    __weak IBOutlet UILabel *datecomplete;
    IBOutlet UIBarButtonItem *editButton;
    __weak IBOutlet UILabel *datecompleteLabel;
    __weak IBOutlet UIScrollView *dateCompleteLine;
    
    __weak IBOutlet UIBarButtonItem *deleteButton;
    IBOutlet UIBarButtonItem *completionButton;
    __weak IBOutlet UIScrollView *scrollView;
}

@property (weak, nonatomic) IBOutlet UIView *label;
- (void)setTask:(Task *)task andWebID: (NSString *) webID;
- (IBAction)completionButtonPressed:(id)sender;
- (IBAction)deleteTask:(id)sender;

@end
