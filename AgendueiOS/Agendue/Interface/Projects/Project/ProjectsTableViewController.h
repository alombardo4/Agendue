//
//  ProjectsTableViewController.h
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TasksTableViewController.h"
#import "Project.h"
#import "iOSRequest.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "AgendueApplication.h"

@interface ProjectsTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
{
    IBOutlet UIBarButtonItem *addButton;
    
}



@end
