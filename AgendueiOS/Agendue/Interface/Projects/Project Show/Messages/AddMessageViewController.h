//
//  AddMessageViewController.h
//  Agendue
//
//  Created by Alec on 7/12/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface AddMessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *messageContent;
- (IBAction)saveMessage:(id)sender;

@end
