//
//  CalendarViewController.m
//  Agendue
//
//  Created by Alec on 11/3/14.
//  Copyright (c) 2014 agendue. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()
{
    NSMutableArray *tasks;
    NSMutableArray *sendTasks;

    NSDate *sendDate;
}
@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationController setToolbarHidden:YES animated:YES];
    [self getCalendarContents];
    sendTasks = [[NSMutableArray alloc] init];

    [self buildCalendarView];
//    [self buildDivider];
    [self buildTableView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView selectRowAtIndexPath:nil animated:NO scrollPosition: 0];
}
- (void)buildCalendarView
{
    _calendarView = [[TSQCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width , self.view.bounds.size.height*0.5)];
    _calendarView.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    _calendarView.firstDate = [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 365 * 1];
    _calendarView.lastDate = [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 365 * 1];
    _calendarView.backgroundColor = UIColorFromRGB(0xeeeeee);
    _calendarView.pagingEnabled = YES;
    [self.view addSubview:_calendarView];
    [_calendarView setDelegate:self];
    [_calendarView scrollToDate:[NSDate dateWithTimeIntervalSinceNow:0] animated:NO];
    [_calendarView setSelectedDate:[NSDate date]];
}

- (void) buildDivider
{
    self.dividerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*.02, self.view.bounds.size.height*0.505, self.view.bounds.size.width*.96, 1.0)];
    [self.dividerImage setImage:[UIImage imageNamed:@"line"]];
    [self.view addSubview: self.dividerImage];
}
-(void)buildTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height*0.51, self.view.bounds.size.width, self.view.bounds.size.height*0.45)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)getCalendarContents {
    [iOSRequest getCalendarOnCompletion:^(NSData *data, NSError *err) {
        dispatch_queue_t main_queue = dispatch_get_main_queue();
        dispatch_async(main_queue, ^{
            if(!err) {
                tasks = [[NSMutableArray alloc] init];
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *names = [dataDictionary valueForKey:@"title"];
                NSArray *webIDs = [dataDictionary valueForKey:@"id"];
                NSArray *dates = [dataDictionary valueForKey:@"start"];
                NSArray *descriptions = [dataDictionary valueForKey:@"description"];
                NSArray *assignedTos = [dataDictionary valueForKey:@"assignedto"];
                NSArray *completeds = [dataDictionary valueForKey:@"complete"];
                NSArray *duedates = [dataDictionary valueForKey:@"duedate"];
                NSArray *datecompletes = [dataDictionary valueForKey:@"datecomplete"];
                NSArray *projectnames = [dataDictionary valueForKey:@"project"];
                NSArray *labels = [dataDictionary valueForKey:@"label"];
                NSArray *personals = [dataDictionary valueForKey:@"personal"];
                NSArray *projectids = [dataDictionary valueForKey:@"projectid"];
                for (int i = 0; i < names.count; i++) {
                    Task *task = [[Task alloc] initWithName:names[i] andWebID:webIDs[i]];
                    
                    if (![descriptions[i] isKindOfClass:[NSNull class]])
                    {
                        task.description = descriptions[i];
                        
                    }
                    if (![duedates[i] isKindOfClass:[NSNull class]])
                    {
                        task.duedate = duedates[i];
                    }
                    if (![assignedTos[i] isKindOfClass:[NSNull class]])
                    {
                        task.assignedto = assignedTos[i];
                    }
                    if (![completeds[i] isKindOfClass:[NSNull class]]
                        && ((NSString *)(completeds[i])).integerValue == 1) {
                        task.complete = YES;
                    }
                    else {
                        task.complete = NO;
                    }
                    if (![personals[i] isKindOfClass:[NSNull class]]
                        && ((NSString *)(personals[i])).integerValue == 1) {
                        task.isPersonal = YES;
                        
                    }
                    else {
                        task.isPersonal = NO;
                        task.projectID = projectids[i];
                    }
                    if (![datecompletes[i] isKindOfClass:[NSNull class]])
                    {
                        task.datecomplete = datecompletes[i];
                    }
                    if (![projectnames[i] isKindOfClass:[NSNull class]]) {
                        task.projectname = projectnames[i];
                    }
                    task.label = [UIColor whiteColor];
                    task.calendarDate = [self getDateFromString:dates[i]];
                    if (![labels[i] isKindOfClass:[NSNull class]])
                    {
                        switch (((int)[labels[i] integerValue])) {
                            case 0:
                                task.label = [UIColor whiteColor];
                                break;
                            case 1:
                                task.label = [UIColor redColor];
                                break;
                            case 2:
                                task.label = [UIColor greenColor];
                                break;
                            case 3:
                                task.label = [UIColor blueColor];
                                break;
                            case 4:
                                task.label = [UIColor yellowColor];
                                break;
                            default:
                                task.label = [UIColor whiteColor];
                                break;
                        }
                    }
                    [tasks addObject:task];
            }
                [self lookupCalendarDate:[NSDate date]];
        }
        });
    }];
}

- (void)calendarView:(TSQCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    [self lookupCalendarDate:date];
}


- (void)lookupCalendarDate: (NSDate *) date
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:date];
    date = [calendar dateFromComponents:components];
    sendTasks = [[NSMutableArray alloc] init];
    for (int i = 0; i < tasks.count; i++)
    {
        Task *task = (Task *)tasks[i];
        if ([task.calendarDate isEqualToDate:date])
        {
            [sendTasks addObject:task];
        }
    }
    [self.tableView reloadData];
    [_tableView setNeedsLayout];
}

-(NSDate *) getDateFromString: (NSString *) str
{
    if ([str class] != [NSNull class])
    {
        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSArray *arr = [str componentsSeparatedByString:@"-"];
        NSInteger comps = (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit);
        NSDate *date = [[NSDate alloc] init];
        NSDateComponents *components = [cal components:comps fromDate:date];
        [components setYear:[arr[0] integerValue]];
        [components setMonth:[arr[1] integerValue]];
        [components setDay:[arr[2] integerValue]];
        date = [cal dateFromComponents:components];
        return date;
    }
    else
    {
        return nil;
    }

}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (sendTasks.count > 0)
    {
        return sendTasks.count;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    MGSwipeTableCell *cell = (MGSwipeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    
    
    if (sendTasks.count == 0) {
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
        Task *object = sendTasks[indexPath.row];
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
        if (object.complete == YES)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[object imageWithLabel]];
        }
    }
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!([[((Task *)sendTasks[indexPath.row]).webID class] isSubclassOfClass:[NSString class]])) {
        if (((Task *)sendTasks[indexPath.row]).isPersonal == YES) {
            [self performSegueWithIdentifier:@"calendarToPersonalTaskDetails" sender:self];
        } else {
            [self performSegueWithIdentifier:@"calendarToTaskDetails" sender:self];
        }
    }
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    if (direction == MGSwipeDirectionRightToLeft) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [_tableView indexPathForCell:cell];
            Task *task = ((Task *) sendTasks[cellIndexPath.row]);
            NSString *webID = task.webID;
            [tasks removeObject:sendTasks[cellIndexPath.row]];
            [sendTasks removeObjectAtIndex:cellIndexPath.row];
            [_tableView reloadData];
            
            dispatch_queue_t main_queue = dispatch_get_main_queue();
            dispatch_async(main_queue, ^{
                if (task.isPersonal == YES) {
                    [iOSRequest deletePersonalTask:webID onCompletion:^(NSData *data, NSError *err) {
                        //
                    }];
                } else {
                    [iOSRequest deleteTask:webID onCompletion:^(NSData *data, NSError *err) {
                        
                    }];
                }
                
            });
        }
    } else if (direction == MGSwipeDirectionLeftToRight) {
        if (index == 0) {
            NSIndexPath *cellIndexPath = [_tableView indexPathForCell:cell];
            Task *task = ((Task *) sendTasks[cellIndexPath.row]);
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
                if (task.isPersonal == YES) {
                    [iOSRequest saveEditedPersonalTask:task.webID withName:task.name description:task.description completed: complete duedate:task.duedate label:[task stringLabel] onCompletion:^(NSData *data, NSError *err) {
                        //
                    }];
                } else {
                    [iOSRequest saveEditedTask:task.webID withName:task.name description:task.description assignment:task.assignedto completed:complete duedate:task.duedate personalDueDate:@"" label: [task stringLabel] onCompletion:^(NSData *data, NSError *err) {
                        
                    }];
                }
                
                [_tableView reloadData];
            });
            
        }
    }
    [self.tableView reloadData];
    
    
    
    
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"calendarToTaskDetails"])
    {
        Task *task = sendTasks[[_tableView indexPathForSelectedRow].row];
        [[segue destinationViewController] setTask:task andWebID:@"null"];
    }
    if ([[segue identifier] isEqualToString:@"calendarToPersonalTaskDetails"])
    {
        Task *task = sendTasks[[_tableView indexPathForSelectedRow].row];
        [[segue destinationViewController] setTask: (Task *) task];
    }
}


- (IBAction)todayButtonPressed:(id)sender {
    [_calendarView scrollToDate:[NSDate dateWithTimeIntervalSinceNow:0] animated:YES];
    _calendarView.selectedDate = [NSDate date];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self getCalendarContents];
    sendTasks = [[NSMutableArray alloc] init];
    
    [self buildCalendarView];
//    [self buildDivider];
    [self buildTableView];
}
@end
