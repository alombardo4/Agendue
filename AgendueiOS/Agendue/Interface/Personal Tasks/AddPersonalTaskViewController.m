//
//  AddPersonalTaskViewController.m
//  Agendue
//
//  Created by Alec on 1/2/15.
//  Copyright (c) 2015 agendue. All rights reserved.
//

#import "AddPersonalTaskViewController.h"

@interface AddPersonalTaskViewController ()

@end

@implementation AddPersonalTaskViewController

- (void)viewDidLoad {
    [self.scrollView setScrollEnabled:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self.scrollView setContentSize:CGSizeMake(320, 490)];

    [super viewDidLoad];
    _labels = @[@"None", @"Red", @"Green", @"Blue", @"Yellow"];
    [self.label setDelegate:self];
    [self.label setDataSource:self];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)duedateswitchChanged:(id)sender {
    if (self.duedateswitch.isOn == NO)
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

- (IBAction)saveTask:(id)sender {
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
        if (self.duedateswitch.isOn == YES)
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
        
        bool complete = NO;
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest addPersonalTaskName:tname withDescription:tdes isCompleted:complete dueDate:tduedate label:label onCompletion:^(NSData *data, NSError *err) {
                //
            }];
        });
        [self.navigationController popViewControllerAnimated:true];

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
    return _labels.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return _labels[row];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
