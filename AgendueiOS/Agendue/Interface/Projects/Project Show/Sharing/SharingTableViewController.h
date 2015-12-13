//
//  SharingTableViewController.h
//  Agendue
//
//  Created by Alec on 3/31/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"
#import "Project.h"
#import "EditProjectViewController.h"
#import "AgendueHTMLParser.h"
@interface SharingTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addShareButton;
- (IBAction)addShareButtonPressed:(id)sender;

- (void)setWebID:(id)webID;
@end
