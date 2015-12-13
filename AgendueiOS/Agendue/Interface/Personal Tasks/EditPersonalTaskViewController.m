//
//  EditPersonalTaskViewController.m
//  Agendue
//
//  Created by Alec on 1/2/15.
//  Copyright (c) 2015 agendue. All rights reserved.
//

#import "EditPersonalTaskViewController.h"

@interface EditPersonalTaskViewController ()

@end

@implementation EditPersonalTaskViewController
{
    Task *_task;
}
-(void) setTask: (Task *) ptask {
    _task = ptask;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.scrollView setContentSize:CGSizeMake(320, 600)];
    
    [super viewDidLoad];
    _labels = @[@"None", @"Red", @"Green", @"Blue", @"Yellow"];
    [self.label setDelegate:self];
    [self.label setDataSource:self];
    self.titleField.text = _task.title;
    self.descriptionField.text = _task.description;
    NSDate *date = [self getDateFromString:_task.duedate];
    if (date != nil && _task.duedate != nil)
    {
        [_duedate setDate:date];
    }
    else
    {
        [_duedate setEnabled:NO];
        [_duedate setHidden:YES];
        [_duedateswitcher setOn:NO];
    }
    
    if (_task.complete == YES) {
        self.complete.selectedSegmentIndex = 1;
    } else {
        self.complete.selectedSegmentIndex = 0;
    }
    
    if ([_task.label isEqual:[UIColor whiteColor]])
    {
        [self.label selectRow:0 inComponent:0 animated:YES];
    }
    else if ([_task.label isEqual:[UIColor redColor]])
    {
        [self.label selectRow:1 inComponent:0 animated:YES];
    }
    else if ([_task.label isEqual:[UIColor greenColor]])
    {
        [self.label selectRow:2 inComponent:0 animated:YES];
    }
    else if ([_task.label isEqual:[UIColor blueColor]])
    {
        [self.label selectRow:3 inComponent:0 animated:YES];
    }
    else if ([_task.label isEqual:[UIColor yellowColor]])
    {
        [self.label selectRow:4 inComponent:0 animated:YES];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _labels.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _labels[row];
}

- (IBAction)deleteButtonPressed:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this task?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteAlert show];
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];

        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest deletePersonalTask:_task.webID onCompletion:^(NSData *data, NSError *err) {
                //
            }];
        });
    }
}

- (IBAction)duedateSwitcher:(id)sender {
    if (self.duedateswitcher.isOn == NO)
    {
        [self.duedate setEnabled:NO];
        [self.duedate setHidden:YES];
    }
    else
    {
        [self.duedate setEnabled:YES];
        [self.duedate setHidden:NO];
    }
    [self.duedate setNeedsDisplay];
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
}

- (IBAction)saveButtonPressed:(id)sender {
    [self.view endEditing:YES];
    NSString *tname = self.titleField.text;
    tname = [tname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tname compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Title" message:@"You cannot have an empty title." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        NSString *tdes = self.descriptionField.text;
        tdes = [tdes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        tdes = [tdes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tduedate = @"";
        if (self.duedateswitcher.isOn == YES)
        {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.duedate.date];
            tduedate = [NSString stringWithFormat:@"%d-%d-%d", components.year, components.month, components.day];
        }
        
        int labelIndex = [self.label selectedRowInComponent:0];
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
        
        NSString *complete = @"false";
        if ([self.complete selectedSegmentIndex] == 1)
        {
            complete = @"true";
        }
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest saveEditedPersonalTask:_task.webID withName:tname description:tdes completed: complete duedate:tduedate label: label onCompletion:^(NSData *data, NSError *err) {
                //
            }];

        });
        [self.navigationController popViewControllerAnimated:true];
        [self.navigationController popViewControllerAnimated:true];

    }
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


@end
