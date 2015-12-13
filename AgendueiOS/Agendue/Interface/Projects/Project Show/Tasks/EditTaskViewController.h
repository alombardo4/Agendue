//
//  EditTaskViewController.h
//  Agendue
//
//  Created by Alec on 12/31/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Task.h"
#import "AgendueHTMLParser.h"
#import "TasksTableViewController.h"

@interface EditTaskViewController : UIViewController {
    NSMutableArray *_emails;
}
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *des;
@property (weak, nonatomic) IBOutlet UISegmentedControl *completed;
@property (weak, nonatomic) IBOutlet UIDatePicker *duedate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UISwitch *enableDueDateSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *assignToScroller;
@property (weak, nonatomic) IBOutlet UIPickerView *labelScroller;

- (IBAction)dueDateSwitchSwitched:(id)sender;
- (void) setTask: (Task *) task AndWebID: (NSString *) webID;
@end
