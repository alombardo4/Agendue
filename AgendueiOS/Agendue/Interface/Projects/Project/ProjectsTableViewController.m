//
//  ProjectsTableViewController.m
//  Agendue
//
//  Created by Alec on 8/7/13.
//  Copyright (c) 2013 agendue. All rights reserved.
//

#import "ProjectsTableViewController.h"

@interface ProjectsTableViewController () {
    NSMutableArray *_objects;
    Project *_temp;
}

@end

@implementation ProjectsTableViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.navigationController.title = @"Projects";
    self.navigationItem.title = @"Projects";
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationController.title = @"Projects";
    self.navigationItem.title = @"Projects";
//    [self configureTable];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self configureTable];
    
}
- (void)orientationChanged:(NSNotification *)notification {
    [self configureTable];
}

- (void)configureTable {
    _objects = [[NSMutableArray alloc] init];
    [iOSRequest getProjectsForUserOnCompletion:^(NSData *results, NSError *error) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!error) {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:results options:0 error:nil];
                NSArray *names = [dataDictionary valueForKey:@"name"];
                NSArray *webIDs = [dataDictionary valueForKey:@"id"];
                if (names.count == 0) {
                    [_objects insertObject:[[Project alloc] initWithName:@"No projects..." andWebID:@"-1"] atIndex:0];
                }
                for (int i = 0; i < names.count; i++) {
                    [_objects insertObject:[[Project alloc] initWithName:names[i] andWebID:webIDs[i]] atIndex:i];
                }
                
            }
            
            dispatch_async(main_queue, ^{
                [self.tableView reloadData];
                [self.tableView setNeedsDisplay];
                [self.tableView setNeedsLayout];
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
    
    if (YES /*SYSTEM_VERSION_LESS_THAN(@"8.0")*/) {
        static NSString *cellIdentifier = @"cell";

        MGSwipeTableCell *cell = (MGSwipeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        
        
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        

        cell.delegate = self;
        
        if ([[NSString stringWithFormat:@"%@", ((Project *) _objects[0]).webID] isEqualToString:@"-1"])
        {
            cell.textLabel.text = @"No projects...";
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.userInteractionEnabled = NO;

        }
        else
        {
            Project *object = _objects[indexPath.row];
            cell.textLabel.text = object.name;
            cell.leftButtons = [self leftButtons];
            cell.rightButtons = [self rightButtons];
            cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
            cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        }
        
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"project_cell" forIndexPath:indexPath];
        if ([[NSString stringWithFormat:@"%@", ((Project *) _objects[0]).webID] isEqualToString:@"-1"])
        {
            cell.textLabel.text = @"No projects...";
            cell.userInteractionEnabled = NO;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        else
        {
            Project *object = _objects[indexPath.row];
            cell.textLabel.text = object.name;
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
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
    
    [leftUtilityButtons addObject:[MGSwipeButton buttonWithTitle:@"Edit" backgroundColor:[UIColor greenColor]]];
    return leftUtilityButtons;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!([[((Project *)_objects[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {

        [self performSegueWithIdentifier:@"projectToTasks" sender:self];
    }
}


/**
 * Called when the user clicks a swipe button or when a expandable button is automatically triggered
 * @return YES to autohide the current swipe buttons
 **/
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    if (direction == MGSwipeDirectionLeftToRight) {
        if(index == 0) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

            _temp = _objects[indexPath.row];
            [self performSegueWithIdentifier:@"projectsToEditProject" sender:self];
        }
    } else if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Project *object = _objects[indexPath.row];
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                [iOSRequest deleteProject:object.webID onCompletion:^(NSData *data, NSError *err) {
                    [self configureTable];
                }];
            });
        }
    }
    return YES;
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
    if ([[segue identifier] isEqualToString:@"projectToTasks"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (_objects.count > indexPath.row) {
            Project *object = _objects[indexPath.row];
            Project *pass = object;
            [[segue destinationViewController] setProject: pass];
        }

    }
    if ([[segue identifier] isEqualToString:@"projectsToEditProject"]) {
        [[segue destinationViewController] setProject: [NSString stringWithFormat:@"%@", _temp.webID]];
    }
}

@end
