//
//  Login.h
//  Agendue
//
//  Created by Alec on 12/18/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "FlowViewController.h"
#import "ProjectsTableViewController.h"
#import "Reachability.h"
#import "AgendueApplication.h"
@interface Login : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *createAccount;
@property (weak, nonatomic) IBOutlet UILabel *welcomeText;
@property (weak, nonatomic) IBOutlet UIImageView *greyBox;
@property (weak, nonatomic) IBOutlet UILabel *welcomeToAgendue;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end
