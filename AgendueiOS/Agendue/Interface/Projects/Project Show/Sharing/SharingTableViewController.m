//
//  SharingTableViewController.m
//  Agendue
//
//  Created by Alec on 3/31/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "SharingTableViewController.h"

@interface SharingTableViewController () {
    NSMutableArray *_objects;
    NSString *_webID;
    bool isSharable;
}

@end

@implementation SharingTableViewController

- (IBAction)addShareButtonPressed:(id)sender {
    if (isSharable == YES) {
        [self performSegueWithIdentifier:@"addShareScreen" sender:self];
    } else {
        UIAlertView *notsharable = [[UIAlertView alloc] initWithTitle:@"Can't Share" message:@"In order to add another team member, everyone on your team must subscribe to Agendue Plus" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [notsharable show];
    }
}

-(void) setWebID:(id)webID {
    _webID = webID;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    _objects = [[NSMutableArray alloc] init];
    
    [iOSRequest getProjectShares:_webID onCompletion:^(NSData *results, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:results options:0 error:nil];
                NSArray *names = [dataDictionary valueForKey:@"name"];
                for (int i = 0; i < names.count; i++) {
                    [_objects addObject:names[i]];
                }
                _objects = [AgendueHTMLParser getSharesFromJSON:results];
                
            }
            dispatch_async(main_queue, ^{
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
                [self.tableView setNeedsLayout];
                [self.view setNeedsDisplay];
                [self.view setNeedsLayout];            });
        });
        
        
        
        
    }];
    
    [iOSRequest getCanShareProject:_webID onCompletion:^(NSData *data, NSError *err) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!err) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSNumber *canshare = (NSNumber *)[dataDictionary valueForKey:@"canshare"];
                if ([canshare boolValue] == NO) {
                    isSharable = NO;
                } else {
                    isSharable = YES;
                }
                
            }
            dispatch_async(main_queue, ^{
                [self.view setNeedsDisplay];
                [self.view setNeedsLayout];            });
        });
    }];
     // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _objects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"team_member_cell" forIndexPath:indexPath];
    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = object;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation
//share_edit_project
// In a storyboard-based application, you will often want to do a little preparation before navigation
*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editProjectSegue"]) {
        [[segue destinationViewController] setProject: _webID];
    }
    if ([[segue identifier] isEqualToString:@"addShareScreen"]) {
        [[segue destinationViewController] setProject: _webID];
    }
}

@end
