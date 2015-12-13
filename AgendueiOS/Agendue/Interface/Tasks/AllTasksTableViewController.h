//
//  TasksTableViewController.h
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"
#import "Task.h"
#import "AgendueHTMLParser.h"
#import "iOSRequest.h"
#import "TaskDetailsViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "AgendueApplication.h"
@interface AllTasksTableViewController : UITableViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
{
    
    IBOutlet UIBarButtonItem *addButton;
    __weak IBOutlet UISegmentedControl *viewSwitcher;
}


- (void)setProject:(id)project;
- (IBAction)deleteProject:(id)sender;
- (IBAction)viewChanged:(id)sender;

@end
