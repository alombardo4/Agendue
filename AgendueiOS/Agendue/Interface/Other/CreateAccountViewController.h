//
//  CreateAccountViewController.h
//  Agendue
//
//  Created by Alec on 1/2/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface CreateAccountViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *fname;
@property (weak, nonatomic) IBOutlet UITextField *lname;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *pword;
@property (weak, nonatomic) IBOutlet UITextField *cpword;
- (IBAction)saveAccount:(id)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *view;

@end
