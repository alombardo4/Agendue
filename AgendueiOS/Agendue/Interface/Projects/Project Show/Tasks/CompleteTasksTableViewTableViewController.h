//
//  CompleteTasksTableViewTableViewController.h
//  Agendue
//
//  Created by Alec on 7/26/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Project.h"
#import "TaskDetailsViewController.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "AgendueApplication.h"
@interface CompleteTasksTableViewTableViewController : UITableViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>

@end
