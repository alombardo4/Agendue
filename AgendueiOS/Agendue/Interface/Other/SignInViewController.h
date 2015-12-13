//
//  SignInViewController.h
//  Agendue
//
//  Created by Alec on 12/13/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "AgendueApplication.h"
@interface SignInViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)runLogin:(id)sender;

@end
