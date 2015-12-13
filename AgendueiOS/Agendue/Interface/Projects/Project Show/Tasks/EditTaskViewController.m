//
//  EditTaskViewController.m
//  Agendue
//
//  Created by Alec on 12/31/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "EditTaskViewController.h"

@interface EditTaskViewController ()
{
    Task *_task;
    NSString *_webID;
    NSArray *_labels;
    
}
@end

@implementation EditTaskViewController
- (IBAction)dueDateSwitchSwitched:(id)sender {
    if (self.enableDueDateSwitch.isOn == NO)
    {
        [self.duedate setEnabled:NO];
        [self.duedate setHidden:YES];
    }
    else {
        [self.duedate setEnabled:YES];
        [self.duedate setHidden:NO];
    }
    [self.duedate setNeedsLayout];
    [self.duedate setNeedsDisplay];
    [self.view setNeedsLayout];
}

- (void) setTask: (Task *) task AndWebID: (NSString *) webID
{
    _task = task;
    _webID = [NSString stringWithFormat:@"%@", webID];
}

- (IBAction)removeTaskPressed:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteAlert show];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1 ] animated:true];
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{

            [iOSRequest deleteTask:_task.webID onCompletion:^(NSData *data, NSError *error) {
            }];
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _labels = @[@"None", @"Red", @"Green", @"Blue", @"Yellow"];
    [self.navigationController setToolbarHidden:true];
	// Do any additional setup after loading the view.
    [self.scrollview setScrollEnabled:YES];
    [self.scrollview setContentSize:CGSizeMake(320, 800)];
    [iOSRequest getProjectShares:_task.projectID onCompletion:^(NSData *data, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                _emails = [[NSMutableArray alloc] init];
                [_emails addObjectsFromArray:[AgendueHTMLParser getSharesFromJSON:data]];
                [_emails addObject:@"None"];
                [self.assignToScroller setNeedsDisplay];
                [self.assignToScroller setNeedsLayout];
                [self.assignToScroller selectRow:(_emails.count - 1) inComponent:0 animated:true];
                _name.text = _task.name;
                self.des.text = _task.description;
                NSDate *date = [self getDateFromString:_task.duedate];
                if (date != nil && _task.duedate != nil)
                {
                    [_duedate setDate:date];
                }
                else
                {
                    [_duedate setEnabled:NO];
                    [_duedate setHidden:YES];
                    [_enableDueDateSwitch setOn:NO];
                }
                
                if (_task.complete == YES) {
                    self.completed.selectedSegmentIndex = 1;
                } else {
                    self.completed.selectedSegmentIndex = 0;
                }
                [self.assignToScroller selectRow:_emails.count - 1 inComponent:0 animated:TRUE];
                for (int i = 0; i < _emails.count; i++) {
                    if ([_task.assignedto compare: _emails[i]] == 0) {
                        [self.assignToScroller selectRow:i inComponent:0 animated:TRUE];
                    }
                }
                
                if ([_task.label isEqual:[UIColor whiteColor]])
                {
                    [self.labelScroller selectRow:0 inComponent:0 animated:YES];
                }
                else if ([_task.label isEqual:[UIColor redColor]])
                {
                    [self.labelScroller selectRow:1 inComponent:0 animated:YES];
                }
                else if ([_task.label isEqual:[UIColor greenColor]])
                {
                    [self.labelScroller selectRow:2 inComponent:0 animated:YES];
                }
                else if ([_task.label isEqual:[UIColor blueColor]])
                {
                    [self.labelScroller selectRow:3 inComponent:0 animated:YES];
                }
                else if ([_task.label isEqual:[UIColor yellowColor]])
                {
                    [self.labelScroller selectRow:4 inComponent:0 animated:YES];
                }

            }
        });
    }];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDate *) getDateFromString: (NSString *) str
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSArray *arr = [str componentsSeparatedByString:@"-"];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit ) fromDate:[NSDate date]];
    [components setYear:[arr[0] integerValue]];
    [components setMonth:[arr[1] integerValue]];
    [components setDay:[arr[2] integerValue]];
    NSDate *date = [cal dateFromComponents:components];
    return date;
}

- (IBAction)saveTask:(id)sender {
    [self.view endEditing:YES];
    NSString *tname = self.name.text;
    tname = [tname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tname compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Name" message:@"You cannot have an empty name." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            NSString *tdes = self.des.text;
            tdes = [tdes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            int assignIndex = [self.assignToScroller selectedRowInComponent:0];
            NSString *assign = _emails[assignIndex];
            if ([assign compare:@"None"] == 0) {
                assign = @"";
            }

            NSString *tduedate = @"null";
            if (self.enableDueDateSwitch.isOn == YES)
            {
                NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.duedate.date];
                tduedate = [NSString stringWithFormat:@"%d-%d-%d", components.year, components.month, components.day];
            }

            NSString* complete = @"false";
            if ([self.completed selectedSegmentIndex] == 1) {
                complete = @"true";
            }
            int labelIndex = [self.labelScroller selectedRowInComponent:0];
            NSString *label;
            switch (labelIndex) {
                case 0:
                    label = @"None";
                    break;
                case 1:
                    label = @"Red";
                    break;
                case 2:
                    label = @"Green";
                    break;
                case 3:
                    label = @"Blue";
                    break;
                case 4:
                    label = @"Yellow";
                    break;
                default:
                    break;
            }
            [iOSRequest saveEditedTask:_task.webID withName:tname description:tdes assignment:assign completed:complete duedate:tduedate personalDueDate:@"" label: label onCompletion:^(NSData *data, NSError *err) {

            }];
        });
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
    }

    
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _assignToScroller)
    {
        return _emails.count;
    }
    else
    {
        return _labels.count;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView == _assignToScroller)
    {
        NSString *data = _emails[row];
        return data;
    }
    else
    {
        NSString *data = _labels[row];
        return data;
    }
}


@end
