//
//  EditPersonalTaskViewController.h
//  Agendue
//
//  Created by Alec on 1/2/15.
//  Copyright (c) 2015 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"
#import "iOSRequest.h"

@interface EditPersonalTaskViewController : UIViewController<UIPickerViewDelegate, UIPickerViewDataSource>
-(void) setTask: (Task *) ptask;
@property NSArray *labels;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIDatePicker *duedate;
@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UISwitch *duedateswitcher;
@property (weak, nonatomic) IBOutlet UIPickerView *label;
@property (weak, nonatomic) IBOutlet UISegmentedControl *complete;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)duedateSwitcher:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@end
