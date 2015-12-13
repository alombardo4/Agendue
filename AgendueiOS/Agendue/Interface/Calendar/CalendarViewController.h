//
//  CalendarViewController.h
//  Agendue
//
//  Created by Alec on 11/3/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Task.h"
#import "TimesSquare.h"
#import "TSQCalendarView.h"
#import "MGSwipeTableCell.h"
#import "PersonalTaskDetailsViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface CalendarViewController : UIViewController<TSQCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate,MGSwipeTableCellDelegate>
@property TSQCalendarView *calendarView;
@property UITableView *tableView;
@property UIImageView *dividerImage;
- (IBAction)todayButtonPressed:(id)sender;
- (IBAction)refreshButtonPressed:(id)sender;
@end
