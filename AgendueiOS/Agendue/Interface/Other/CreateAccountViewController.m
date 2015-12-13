//
//  CreateAccountViewController.m
//  Agendue
//
//  Created by Alec on 1/2/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()

@end

@implementation CreateAccountViewController

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
    [self.scrollView setScrollEnabled:YES];
    [self.scrollView setContentSize:CGSizeMake(320, 500)];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAccount:(id)sender {
    if ([_email hasText] && [_pword hasText] && [_cpword hasText] && [_fname hasText] && [_lname hasText]) {
        [iOSRequest createAccountEmail:_email.text firstName:_fname.text lastName:_lname.text password:_pword.text passwordConfirm:_cpword.text
                          onCompletion:^(NSData *data, NSError *err) {
                              dispatch_queue_t main_queue = dispatch_get_main_queue();
                              dispatch_async(main_queue, ^{
                                  if(!err) {
                                      
                                      NSString *res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                      if ([res rangeOfString:@"name"].location == NSNotFound) {
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account not created" message:@"Either your email address has already been used or your passwords do not match." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                                          [alert show];
                                      } else {
                                          NSString *output = [[NSString alloc] initWithFormat:@"%@\n%@", _email.text, _pword.text ];
                                          
                                          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                                          NSString *documentsDirectory = [paths objectAtIndex:0];
                                          NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@".txt"];
                                          
                                          
                                          [output writeToFile:filePath atomically:TRUE encoding:NSUTF8StringEncoding error:NULL];
                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account created successfully!" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
                                          [alert show];
                                          [self performSegueWithIdentifier:@"accountCreatedLogin" sender:self];
                                      }

                                  }
                              });
                              
                              
                              
        }];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account not created" message:@"You must fill out all fields." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }

}
@end
