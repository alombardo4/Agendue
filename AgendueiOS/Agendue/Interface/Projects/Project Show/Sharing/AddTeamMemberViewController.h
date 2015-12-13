//
//  AddTeamMemberViewController.h
//  Agendue
//
//  Created by Alec on 7/6/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface AddTeamMemberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
- (IBAction)saveButtonPressed:(id)sender;
- (void)setProject: (NSString *) webID;
@end
