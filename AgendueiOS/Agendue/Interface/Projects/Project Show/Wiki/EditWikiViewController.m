//
//  EditWikiViewController.m
//  Agendue
//
//  Created by Alec on 8/21/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "EditWikiViewController.h"

@interface EditWikiViewController ()
{
    NSString *_wiki;
    NSString *_project;
}
@end

@implementation EditWikiViewController

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
        [self.navigationController setToolbarHidden:YES animated:YES];
    NSString *url = [NSString stringWithFormat:@"https://agendue.com/projects/%@/wiki/edit?", _project];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"GET"];
    [self.wikiViewer loadRequest:request];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setProject:(id)project
{
    if (_project != project) {
        _project = project;
    }
}

@end
