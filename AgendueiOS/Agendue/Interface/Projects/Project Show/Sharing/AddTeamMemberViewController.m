//
//  AddTeamMemberViewController.m
//  Agendue
//
//  Created by Alec on 7/6/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "AddTeamMemberViewController.h"

@interface AddTeamMemberViewController () {
    NSString *_project;
}

@end

@implementation AddTeamMemberViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setProject: (NSString *) webID {
    _project = webID;
}


- (IBAction)saveButtonPressed:(id)sender {
    [self.view endEditing:YES];
    if ([[self.emailEntry.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Email Address" message:@"You cannot have an empty email address." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest addShare:self.emailEntry.text toProjectWithId:_project onCompletion:^(NSData *data, NSError *err) {
            }];
        });
        [self.navigationController popViewControllerAnimated:true];
    }


}
@end
