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
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "AgendueApplication.h"

@interface YourTasksTableViewController : UITableViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
{
    
    IBOutlet UIBarButtonItem *addButton;
    __weak IBOutlet UISegmentedControl *viewSwitcher;
}
- (IBAction)viewChanged:(id)sender;


@end
