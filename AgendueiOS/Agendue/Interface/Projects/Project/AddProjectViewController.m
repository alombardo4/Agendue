//
//  AddProjectViewController.m
//  Agendue
//
//  Created by Alec on 12/20/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "AddProjectViewController.h"

@interface AddProjectViewController ()

@end

@implementation AddProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveProject:(id)sender {
    [self.view endEditing:YES];
    NSString *projName = _projectName.text;
    projName = [projName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([projName compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Name" message:@"You cannot have an empty name." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest addProject:projName onCompletion:^(NSData *data, NSError *err) {
            }];
        });
        [self.navigationController popToRootViewControllerAnimated:true];

    }
}
@end
