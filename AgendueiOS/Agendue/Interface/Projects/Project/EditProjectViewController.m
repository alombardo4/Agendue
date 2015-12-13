//
//  EditProjectViewController.m
//  Agendue
//
//  Created by Alec on 12/30/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "EditProjectViewController.h"

@interface EditProjectViewController ()
{
    NSString *project;
}
@end

@implementation EditProjectViewController

- (void) setProject: (NSString *) p
{
    project = p;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];

    [iOSRequest getProjectsForUserOnCompletion:^(NSData *results, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:results options:0 error:nil];
                NSArray *names = [dataDictionary valueForKey:@"name"];
                NSArray *webIDs = [dataDictionary valueForKey:@"id"];
                for (int i = 0; i < names.count; i++) {
                    if ([[NSString stringWithFormat:@"%@", webIDs[i]] compare:project] == 0) {
                        _projectName.text = names[i];
                    }

                }
            }
            dispatch_async(main_queue, ^{
                [self.view setNeedsDisplay];
                [self.view setNeedsLayout];            });
        });
    }];
    [self.projectName becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        dispatch_queue_t main_queue = dispatch_get_main_queue();

        dispatch_async(main_queue, ^{

            [iOSRequest deleteProject:project onCompletion:^(NSData *data, NSError *error) {
            }];
        });
        [self.navigationController popToRootViewControllerAnimated:true];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)saveProject:(id)sender {
    [self.view endEditing:YES];
    NSString *pName = _projectName.text;
    pName = [pName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([pName compare:@""] == 0) {
        UIAlertView *bad = [[UIAlertView alloc] initWithTitle:@"Empty Name" message:@"You cannot have an empty name." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [bad show];
    } else {
        NSString *share = @"";
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        
        dispatch_async(main_queue, ^{
            [iOSRequest editProject:project withName:pName andShareWith:share onCompletion:^(NSData *results, NSError *error) {
            }];
        });

        [self.navigationController popViewControllerAnimated:YES];

    }

    
}

@end
