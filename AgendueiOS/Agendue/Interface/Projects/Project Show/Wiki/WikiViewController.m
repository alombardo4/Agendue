//
//  WikiViewController.m
//  Agendue
//
//  Created by Alec on 6/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "WikiViewController.h"

@interface WikiViewController ()

@end

@implementation WikiViewController
{
    NSString *_wiki;
    NSString *_project;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    // Do any additional setup after loading the view.
    [self.navigationController setToolbarHidden:YES animated:YES];
    [iOSRequest getWikiForProject:_project onCompletion:^(NSData *results, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:results options:0 error:nil];
                _wiki = [dataDictionary valueForKey:@"wiki"];

            }
            dispatch_async(main_queue, ^{
                if (_wiki != nil && [_wiki class] != [NSNull class]) {
                    [self.wikiViewer loadHTMLString:_wiki baseURL:nil];
                } else {
                    [self.wikiViewer loadHTMLString:@"You have an empty notebook..." baseURL:nil];
                }
                [self.view setNeedsDisplay];
                [self.view setNeedsLayout];            });
        });
    }];
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"wikiToEditWiki"]) {
        [[segue destinationViewController] setProject:_project];
        
    }
}
- (void)setProject:(id)project
{
    if (_project != project) {
        _project = project;
    }
}

@end
