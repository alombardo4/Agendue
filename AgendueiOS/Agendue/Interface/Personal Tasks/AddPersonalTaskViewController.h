//
//  AddPersonalTaskViewController.h
//  Agendue
//
//  Created by Alec on 1/2/15.
//  Copyright (c) 2015 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface AddPersonalTaskViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property NSArray *labels;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIDatePicker *duedate;
@property (weak, nonatomic) IBOutlet UISwitch *duedateswitch;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIPickerView *label;
- (IBAction)duedateswitchChanged:(id)sender;
- (IBAction)saveTask:(id)sender;

@end
