//
//  AddProjectViewController.h
//  Agendue
//
//  Created by Alec on 12/20/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface AddProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectName;
- (IBAction)saveProject:(id)sender;
@end
