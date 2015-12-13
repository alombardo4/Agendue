//
//  LandingViewController.h
//  Agendue
//
//  Created by Alec on 10/11/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Task.h"
#import "Project.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"
#import "TaskDetailsViewController.h"
#import "PersonalTaskDetailsViewController.h"
#import "AgendueApplication.h"

@interface LandingViewController : UIViewController<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *productivityScoreWebView;
@property (weak, nonatomic) IBOutlet UITableView *upcomingTasksTableView;
@property (weak, nonatomic) IBOutlet UILabel *productivityScoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *tabSegmentController;
- (IBAction)segmentedControlValueChanged:(id)sender;


@end
