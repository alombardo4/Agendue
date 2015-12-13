//
//  TasksTableViewController.m
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "AllTasksTableViewController.h"

@interface AllTasksTableViewController () {
    Project *_project;
    NSMutableArray *_objects;
}

@end


@implementation AllTasksTableViewController


- (void)setProject:(id)project
{
    if (_project != project) {
        _project = project;
    }
}

- (IBAction)deleteProject:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure you want to delete this project?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [deleteAlert show];

}

- (IBAction)viewChanged:(id)sender {
    [self configureTable];

    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.navigationController setToolbarHidden:true];
    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:true];

    [self configureTable];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)insertNewObject:(id)sender
//{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:sender atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.leftButtons = [self leftButtons];
        cell.rightButtons = [self rightButtons];
        cell.delegate = self;
        Task *object = _objects[indexPath.row];
        cell.textLabel.text = object.name;
        if ((object.assignedto == nil  || [object.assignedto isKindOfClass:[NSNull class]]
             || [object.assignedto isEqualToString:@"None"])
            && (object.duedate == nil || [object.duedate isKindOfClass:[NSNull class]])) {
            cell.detailTextLabel.text = @"";
        } else if (object.assignedto == nil || [object.assignedto isKindOfClass:[NSNull class]]
                   || [object.assignedto isEqualToString:@"None"]) {
            cell.detailTextLabel.text = object.duedate;
        } else if (object.duedate == nil || [object.duedate isKindOfClass: [NSNull class]]) {
            cell.detailTextLabel.text = object.assignedto;
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", object.assignedto, object.duedate];
        }
        cell.accessoryView = [[UIImageView alloc] initWithImage:[object imageWithLabel]];

    }
    
    return cell;

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
                [iOSRequest deleteTask:webID onCompletion:^(NSData *data, NSError *err) {
                    
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
                } else {
                }

                [iOSRequest saveEditedTask:task.webID withName:task.name description:task.description assignment:task.assignedto completed:complete duedate:task.duedate personalDueDate:@"" label:[task stringLabel] onCompletion:^(NSData *data, NSError *err) {
                    
                }];
            });
            [_objects removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
  
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!([[((Task *)_objects[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {

        [self performSegueWithIdentifier:@"TasksToDetails" sender:self];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TasksToDetails"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (_objects.count > indexPath.row) {
            Task *object = _objects[indexPath.row];
            [[segue destinationViewController] setTask:object andWebID:@"null"];
        }

    }
//    if ([[segue identifier] isEqualToString:@"editProjectStart"]) {
//        [[segue destinationViewController] setProject: _project.webID];
//    }
//    if ([[segue identifier] isEqualToString:@"addTask"]) {
//        [[segue destinationViewController] setWebID:_project.webID];
//    }
//    if ([[segue identifier] isEqualToString:@"ProjectSharingOpener"]) {
//        [[segue destinationViewController] setWebID:_project.webID];
//    }
}

-(void) configureTable {
    if (viewSwitcher.selectedSegmentIndex == 0) {
        _objects = [[NSMutableArray alloc] init];
        [iOSRequest getAllIncompleteTasksOnCompletion:^(NSData *results, NSError *err) {
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
        _objects = [[NSMutableArray alloc] init];
        [iOSRequest getAllCompleteTasksOnCompletion:^(NSData *results, NSError *err) {
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

@end