//
//  LandingViewController.m
//  Agendue
//
//  Created by Alec on 10/11/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()
{
    NSMutableArray *_objects;
    Project *_project;
}

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setNeedsDisplay];
    [self.view setNeedsLayout];
    [self.tabSegmentController setSelectedSegmentIndex:0];
    [self.upcomingTasksTableView setDelegate:self];
    [self.upcomingTasksTableView setDataSource:self];
    [self.navigationController setToolbarHidden:true];
    
    [self configureLabel];
    [self configureUpcomingTable];
//    [self configurePersonalTable];
}

-(void) configureLabel {
    [iOSRequest getLandingIncompleteOnCompletion:^(NSData *data, NSError *err) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            NSDictionary *scoreDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            int intsum = [[scoreDict valueForKey:@"count"] intValue];
            NSString *sumtext;
            if (intsum == 0)
            {
                sumtext = @"You have no incomplete tasks.";
            }
            else if (intsum == 1)
            {
                sumtext = @"You have 1 task to do today.";
            }
            else
            {
                sumtext = [NSString stringWithFormat:@"You have %i tasks to do today.", intsum];
            }
            _productivityScoreLabel.text = sumtext;
            [self.view setNeedsDisplay];
        });

    }];
}


- (void) configureUpcomingTable {
    _objects = [[NSMutableArray alloc] init];
    if (self.tabSegmentController.selectedSegmentIndex == 1) {
        [iOSRequest getLandingPersonalOnCompletion:^(NSData *results, NSError *err) {
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                dispatch_async(main_queue, ^{
                    if(!err) {
                        _objects = [AgendueHTMLParser getTasksFromJSON:results];
                        [self.upcomingTasksTableView reloadData];
                    }
                    dispatch_async(main_queue, ^{
                        //                [alert dismissWithClickedButtonIndex:-1 animated:YES];
                        [self.upcomingTasksTableView
                         reloadData];
                        [self.view setNeedsDisplay];
                    });
                });
            });
        }];
    } else if (self.tabSegmentController.selectedSegmentIndex == 0) {
        [iOSRequest getAssignedIncompleteTasksOnCompletion:^(NSData *results, NSError *err) {
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                dispatch_async(main_queue, ^{
                    if(!err) {
                        _objects = [AgendueHTMLParser getTasksFromJSON:results];
                        [self.upcomingTasksTableView reloadData];
                    }
                    dispatch_async(main_queue, ^{
                        //                [alert dismissWithClickedButtonIndex:-1 animated:YES];
                        [self.upcomingTasksTableView reloadData];
                        [self.view setNeedsDisplay];
                    });
                });
            });
        }];
    }

    
}

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
        cell.leftButtons = [self leftButtons];
        cell.rightButtons = [self rightButtons];
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.delegate = self;
        Task *object;
        object = _objects[indexPath.row];
        cell.textLabel.text = object.name;
        if ((object.assignedto == nil  || [object.assignedto isKindOfClass:[NSNull class]]
             || [object.assignedto isEqualToString:@"None"])
            && (object.duedate == nil || [object.duedate isKindOfClass:[NSNull class]])) {
            cell.detailTextLabel.text = @"";
        } else if (object.assignedto == nil || [object.assignedto isKindOfClass:[NSNull class]]
                   || [object.assignedto isEqualToString:@"None"]) {
            cell.detailTextLabel.text = object.duedate;
        } else if (object.duedate == nil || [object.duedate isKindOfClass: [NSNull class]]) {
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", object.duedate];
        }
        cell.accessoryView = [[UIImageView alloc] initWithImage:[object imageWithLabel]];
        
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (((Task *) _objects[indexPath.row]).isPersonal == YES) {
        if (!([[((Task *)_objects[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {
            
            [self performSegueWithIdentifier:@"landingToPersonalDetails" sender:self];
        }
    } else {
        if (!([[((Task *)_objects[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {
            
            [self performSegueWithIdentifier:@"upcomingToDetails" sender:self];
        }
    }

}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [self.upcomingTasksTableView indexPathForCell:cell];
            Task *task = (Task *) _objects[cellIndexPath.row];
            if (task.isPersonal == YES) {
                dispatch_queue_t main_queue = dispatch_get_main_queue();
                dispatch_async(main_queue, ^{
                    [iOSRequest deletePersonalTask:task.webID onCompletion:^(NSData *data, NSError *err) {
                        //
                    }];
                });
            } else {
                NSString *webID = task.webID;

                
                dispatch_queue_t main_queue = dispatch_get_main_queue();
                dispatch_async(main_queue, ^{
                    [iOSRequest deleteTask:webID onCompletion:^(NSData *data, NSError *err) {
                        
                    }];
                });
            }
            [_objects removeObjectAtIndex:cellIndexPath.row];
            [self.upcomingTasksTableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                               withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.upcomingTasksTableView reloadData];

        }
    } else if (direction == MGSwipeDirectionLeftToRight) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [self.upcomingTasksTableView indexPathForCell:cell];
            Task *task = ((Task *) _objects[cellIndexPath.row]);
            if (task.isPersonal == YES) {
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
                    [iOSRequest saveEditedPersonalTask:task.webID withName:task.name description:task.description completed:complete duedate:task.duedate label:[task stringLabel] onCompletion:^(NSData *data, NSError *error) {
                        //;
                    }];
                });
            } else {
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
                    [iOSRequest saveEditedTask:task.webID withName:task.name description:task.description assignment:task.assignedto completed:complete duedate:task.duedate personalDueDate:@"" label: [task stringLabel] onCompletion:^(NSData *data, NSError *err) {
                        
                    }];
                });
            }

            [_objects removeObjectAtIndex:cellIndexPath.row];
            [self.upcomingTasksTableView deleteRowsAtIndexPaths:@[cellIndexPath]
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
#pragma mark - Navigation
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"upcomingToDetails"]) {
        NSIndexPath *indexPath = [self.upcomingTasksTableView indexPathForSelectedRow];
        if (_objects.count > indexPath.row) {
            Task *object = _objects[indexPath.row];
            [[segue destinationViewController] setTask:object andWebID:@"null"];
        }
        
    }

    if ([[segue identifier] isEqualToString:@"landingToPersonalDetails"]) {
        NSIndexPath *indexPath = [self.upcomingTasksTableView indexPathForSelectedRow];
        if (_objects.count > indexPath.row) {
            Task *object = _objects[indexPath.row];
            [[segue destinationViewController] setTask:object];
        }
        
    }
}
- (IBAction)segmentedControlValueChanged:(id)sender {
    [self configureUpcomingTable];
}
@end
