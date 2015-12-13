//
//  AddTaskViewController.m
//  Agendue
//
//  Created by Alec on 12/20/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "AddTaskViewController.h"

@interface AddTaskViewController ()
{
    NSString *webID;
    NSArray *_labels;
}

@end

@implementation AddTaskViewController
- (void) setWebID: (NSString *) num
{
    webID = num;
    _labels = @[@"None", @"Red", @"Green", @"Blue", @"Yellow"];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _labels = @[@"None", @"Red", @"Green", @"Blue", @"Yellow"];

    _emails = [[NSMutableArray alloc] init];
    

    [iOSRequest getProjectsForUserOnCompletion:^(NSData *results, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:results options:0 error:nil];
                NSArray *webIDs = [dataDictionary valueForKey:@"id"];
                NSArray *shares = [dataDictionary valueForKey:@"allshares"];
                for (int i = 0; i < webIDs.count; i++) {
                    NSString *project = webIDs[i];
                    if ([project compare:webID] == 0) {
                        if ([shares[i] rangeOfString:@","].length > 0) {
                            NSArray *pShares = [shares[i] componentsSeparatedByString:@","];
                            int index = 0;
                            for (int j = 0; j < pShares.count; j++) {
                                if ([(NSString *)pShares[j] compare:@""] != 0) {
                                    [_emails insertObject:pShares[j] atIndex:index];
                                    index++;
                                }
                            }
                            [_emails addObject:@"None"];
                        } else {
                            [_emails addObject:shares[i]];
                            [_emails addObject:@"None"];
                        }
                        
                    }
                    
                }
                
            }
            dispatch_async(main_queue, ^{
                [self.assignPicker setNeedsDisplay];
                [self.assignPicker setNeedsLayout];
                [self.assignPicker selectRow:(_emails.count - 1) inComponent:0 animated:true];

            });
        });
    }];
     
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setScrollEnabled:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];

    [self.scrollView setContentSize:CGSizeMake(320, 760)];
	// Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveTask:(id)sender {
    [self.view endEditing:YES];
    NSString *tname = self.name.text;
    tname = [tname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([tname compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Name" message:@"You cannot have an empty name." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        NSString *tdes = self.des.text;
        tdes = [tdes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        int assignIndex = [self.assignPicker selectedRowInComponent:0];
        NSString *assign = _emails[assignIndex];
        tdes = [tdes stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tduedate = @"";
        if (_enableDueDateSwitch.isOn == YES)
        {
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.dueDate.date];
            tduedate = [NSString stringWithFormat:@"%d-%d-%d", components.year, components.month, components.day];
        }

        int labelIndex = [self.labelPicker selectedRowInComponent:0];
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
            [iOSRequest addTaskName:tname withDescription:tdes assignedTo:assign isCompleted:complete dueDate:tduedate personalDueDate:nil label: label toProject:webID onCompletion:^(NSData *results, NSError *err) {
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
    if (pickerView == _assignPicker)
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
    if (pickerView == _assignPicker)
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
- (IBAction)dueDateSwitchSwitched:(id)sender {
    if (_enableDueDateSwitch.isOn == NO)
    {
        [self.dueDate setEnabled:NO];
        [self.dueDate setHidden:YES];
    }
    else
    {
        [self.dueDate setEnabled:YES];
        [self.dueDate setHidden:NO];
    }
    [self.dueDate setNeedsDisplay];
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
}
@end
