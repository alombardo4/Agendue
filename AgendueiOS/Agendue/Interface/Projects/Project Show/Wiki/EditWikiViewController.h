//
//  EditWikiViewController.h
//  Agendue
//
//  Created by Alec on 8/21/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iOSRequest.h"

@interface EditWikiViewController : UIViewController
- (void)setProject:(id)project;
@property (weak, nonatomic) IBOutlet UIWebView *wikiViewer;

@end
