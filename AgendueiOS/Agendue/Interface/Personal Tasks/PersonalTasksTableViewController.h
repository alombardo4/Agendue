//
//  IncompletePersonalTasksTableViewController.h
//  Agendue
//
//  Created by Alec on 12/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgendueHTMLParser.h"
#import "iOSRequest.h"
#import "MGSwipeButton.h"
#import "MGSwipeTableCell.h"
#import "AgendueApplication.h"
#import "PersonalTaskDetailsViewController.h"

@interface PersonalTasksTableViewController : UITableViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *completeSwitcher;
- (IBAction)completeSwitcherValueChanged:(id)sender;

@end
