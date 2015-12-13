//
//  AddMessageViewController.m
//  Agendue
//
//  Created by Alec on 7/12/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "AddMessageViewController.h"

@interface AddMessageViewController ()

@end

@implementation AddMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [_messageContent becomeFirstResponder];
    
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

- (IBAction)saveMessage:(id)sender {
    [self.view endEditing:YES];
    NSString *messageCont = _messageContent.text;
    messageCont = [messageCont stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([messageCont compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Message" message:@"You cannot save an empty message." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            [iOSRequest addMessage:messageCont onCompletion:^(NSData *data, NSError *error) {
            }];
        });
        [self.navigationController popViewControllerAnimated:true];

    }
}
@end
