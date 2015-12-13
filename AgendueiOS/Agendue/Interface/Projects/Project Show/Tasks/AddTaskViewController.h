//
//  AddTaskViewController.h
//  Agendue
//
//  Created by Alec on 12/20/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface AddTaskViewController : UIViewController {
    NSMutableArray *_emails;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *des;

@property (weak, nonatomic) IBOutlet UIDatePicker *dueDate;
@property (weak, nonatomic) IBOutlet UIPickerView *assignPicker;
@property (weak, nonatomic) IBOutlet UISwitch *enableDueDateSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *labelPicker;
- (IBAction)dueDateSwitchSwitched:(id)sender;

@end
