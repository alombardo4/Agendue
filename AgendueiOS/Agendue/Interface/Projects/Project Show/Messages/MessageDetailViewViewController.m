//
//  MessageDetailViewViewController.m
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "MessageDetailViewViewController.h"

@interface MessageDetailViewViewController ()

@end

@implementation MessageDetailViewViewController
{
    Message *_message;
}
-(void)setMessage: (Message *) inputMessage
{
    _message = inputMessage;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.contentLabel setText:_message.content];
    [_contentLabel sizeToFit];
    [self.senderName setText:_message.user];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


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

@end
