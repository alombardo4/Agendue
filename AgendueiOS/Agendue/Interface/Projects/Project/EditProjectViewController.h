//
//  EditProjectViewController.h
//  Agendue
//
//  Created by Alec on 12/30/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface EditProjectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *projectName;
- (void) setProject: (NSString *) p;
- (IBAction)saveProject:(id)sender;

@end
