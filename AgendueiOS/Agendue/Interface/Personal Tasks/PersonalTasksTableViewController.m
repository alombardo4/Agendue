//
//  IncompletePersonalTasksTableViewController.m
//  Agendue
//
//  Created by Alec on 12/30/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "PersonalTasksTableViewController.h"

@interface PersonalTasksTableViewController () {
    NSMutableArray *_objects;
}

@end

@implementation PersonalTasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.navigationController setToolbarHidden:true];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:true];
    
    [self configureTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    MGSwipeTableCell *cell = (MGSwipeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    
    if ([[NSString stringWithFormat:@"%@", ((Task *) _objects[0]).webID] isEqualToString:@"-1"]) {
        cell.textLabel.text = @"No tasks...";
        cell.detailTextLabel.text = @"";
        cell.userInteractionEnabled = NO;
        cell.accessoryView = [[UIImageView alloc] init];
        
    } else {
        cell.leftButtons = [self leftButtons];
        cell.rightButtons = [self rightButtons];
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.delegate = self;
        Task *object = _objects[indexPath.row];
        cell.textLabel.text = object.name;
        cell.detailTextLabel.text = object.duedate;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[object imageWithLabel]];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!([[((Task *)_objects[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {
        
        [self performSegueWithIdentifier:@"personalTaskDetails" sender:self];
    }
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            NSString *webID = ((Task *) _objects[cellIndexPath.row]).webID;
            [_objects removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView reloadData];
            
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                [iOSRequest deletePersonalTask:webID onCompletion:^(NSData *data, NSError *err) {
                    
                }];
            });
        }
    } else if (direction == MGSwipeDirectionLeftToRight) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            Task *task = ((Task *) _objects[cellIndexPath.row]);
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                
                task.complete = !task.complete;
                NSString* complete = @"false";
                if (task.complete == 1) {
                    complete = @"true";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                [iOSRequest saveEditedPersonalTask:task.webID withName:task.name description:task.description completed:complete duedate:task.duedate label: [task stringLabel] onCompletion:^(NSData *data, NSError *err) {
                    //
                }];
                 
            });
            [_objects removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    }
    
    
    return YES;
}

- (NSArray *) rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons addObject:[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor]]];
    
    return rightUtilityButtons;
}

- (NSArray *) leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    [leftUtilityButtons addObject:[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"markcomplete.png"] backgroundColor:[UIColor greenColor]]];
    
    return leftUtilityButtons;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"personalTaskDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (_objects.count > indexPath.row) {
            Task *object = _objects[indexPath.row];
            [[segue destinationViewController] setTask:object];
        }
        
    }
}


-(void) configureTable {
    if (_completeSwitcher.selectedSegmentIndex == 0) {
        [iOSRequest getIncompletePersonalTasksOnCompletion:^(NSData *results, NSError *err) {
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                if(!err) {
                    _objects = [AgendueHTMLParser getTasksFromJSON:results];
                    [self.tableView reloadData];
                }
                dispatch_async(main_queue, ^{
                    //                [alert dismissWithClickedButtonIndex:-1 animated:YES];
                    [self.tableView reloadData];
                    [self.view setNeedsDisplay];
                });
                
            });
            
            
            
            
        }];
    } else {
        [iOSRequest getCompletePersonalTasksOnCompletion:^(NSData *results, NSError *err) {
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                if(!err) {
                    _objects = [AgendueHTMLParser getTasksFromJSON:results];
                    [self.tableView reloadData];
                }
                dispatch_async(main_queue, ^{
                    //                [alert dismissWithClickedButtonIndex:-1 animated:YES];
                    [self.tableView reloadData];
                    [self.view setNeedsDisplay];
                });
            });
            
            
            
            
        }];
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}


- (IBAction)completeSwitcherValueChanged:(id)sender {
    [self configureTable];
    [self.tableView reloadData];
}
@end
