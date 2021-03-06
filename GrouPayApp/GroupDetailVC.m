//
//  GroupDetailVC.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "GroupDetailVC.h"
#import "Event.h"
#import "User.h"
#import "EventDetailVC.h"
#import "AppDelegate.h"

@interface GroupDetailVC ()

@end

@implementation GroupDetailVC
@synthesize  eventArray, memberArray;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*NSLog(@"Selected goup name : %@", [group name]);
    NSLog(@"Selected goup name : %@", [group group_id]);
    NSLog(@"Selected goup name : %@", [group admin_id]);
    NSLog(@"Selected goup name : %@", [group created_date]);*/
    eventArray = [[NSMutableArray alloc] init];
    memberArray = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    //add event button
    UIBarButtonItem *btnAddEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
    [self.navigationItem setRightBarButtonItem:btnAddEvent];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchGroups];
    //[self fetchEvents];
}

- (IBAction)addEvent:(id)sender {
    AddEventViewController *addEventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddEventViewController"];
    addEventVC.selectedGroup = _selectedGroup;
    [self.navigationController pushViewController:addEventVC animated:YES];
}

- (void)fetchEvents {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = appDelegate.userDetails;
    NSString *post =[[NSString alloc] initWithFormat:@"api=get_events&user_id=%@", currentUser.user_id];
    NSURL *url = [NSURL URLWithString:@"http://iqmicrosystems.com/groupay/v1/api.php?"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:kNilOptions timeoutInterval:20];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [urlRequest setURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(responseData && !error) {
        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        NSError *error = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if([[responseDictionary allKeys] count] > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success !" message:@"Event added successfully !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

- (void)fetchGroups {
    NSString *post =[[NSString alloc] initWithFormat:@"api=get_group_info&group_id=%@", _selectedGroup.group_id];
    NSURL *url=[NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //[SVProgressHUD showWithStatus:@"Loading groups..." maskType:SVProgressHUDMaskTypeGradient networkIndicator:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //[SVProgressHUD dismiss];
        
        if (connectionError) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Server not responding for your request. Please try later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            [eventArray removeAllObjects];
            [memberArray removeAllObjects];
            NSArray *eventsArray = [jsonData valueForKey:@"1"];
            //event_id, name, description, start_time, end_time, creator_id, fee
            for(int i = 0; i < [eventsArray count]; i++){
                //[[[jsonData valueForKey:@"1"] objectAtIndex:i] valueForKey:@"name"]
                NSString *eventName = [[eventsArray objectAtIndex:i] valueForKey:@"name"];
                NSString *eventId = [[eventsArray objectAtIndex:i] valueForKey:@"event_id"];
                NSString *description = [[eventsArray objectAtIndex:i] valueForKey:@"description"];
                NSString *startTime = [[eventsArray objectAtIndex:i] valueForKey:@"start_time"];
                NSString *endTime = [[eventsArray objectAtIndex:i] valueForKey:@"end_time"];
                NSString *creatorId = [[eventsArray objectAtIndex:i] valueForKey:@"creator_id"];
                NSString *fee = [[eventsArray objectAtIndex:i] valueForKey:@"fee"];
                Event *event = [[Event alloc] init];
                [event setName:eventName];
                [event setEvent_id:eventId];
                [event setDescription:description];
                [event setStart_time:startTime];
                [event setEnd_time:endTime];
                [event setCreator_id:creatorId];
                [event setFee:fee];
                [[self eventArray] addObject:event];
            }
            
            NSArray *userArray = [jsonData valueForKey:@"0"];
            //user_id, name, email, phone_no, password
            for(int i = 0; i < [userArray count]; i++){
                //[[[jsonData valueForKey:@"1"] objectAtIndex:i] valueForKey:@"name"]
                NSString *name = [[userArray objectAtIndex:i] valueForKey:@"name"];
                NSString *userId = [[userArray objectAtIndex:i] valueForKey:@"user_id"];
                NSString *email = [[userArray objectAtIndex:i] valueForKey:@"email"];
                
                User *user = [[User alloc] init];
                [user setName:name];
                [user setUser_id:userId];
                [user setEmail:email];
                [[self memberArray] addObject:user];
            }
            /*[array enumerateObjectsUsingBlock:^(NSDictionary *blockArray, NSUInteger idx, BOOL *stop) {
                
                NSLog(@"EACH BOCK %@", blockArray);
                for (NSArray *arr in blockArray[@"events"]) {
                        NSLog(@"EACH BOCK event %@", arr);
                    
                    //[jsonDataArray addObject:arr];
                }
                
                 jsonResorts = [self performSelector:@selector(fetchDataFromUrl) withObject:nil];
                 jsonDataArray = [[NSMutableArray alloc] init];
                 for (NSArray *arr in jsonResorts) {
                 [jsonDataArray addObject:arr];
                 }
                 
                 
                 Group *group = [[Group alloc]init];
                group.group_id = groupItem[@"group_id"];
                group.name = groupItem[@"name"];
                group.admin_id = groupItem[@"admin_id"];
                group.created_date = groupItem[@"created_date"];
                
                [groupsArray addObject:group];
            }];*/
            
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
        return [eventArray count];
    }
    else if (section == 1){
        return [memberArray count];
    }
    else
        return 1;
    
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return @"My Events";
    }
    else if(section == 1) {
        return @"Group Members";
    }
    else
        return @"Leave Group";
    
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0) {
        Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [event name];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1) {
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];

        cell.textLabel.text = [user name];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaveGroupCell"];
        UIButton *btnLeaveGroup = (UIButton *)[cell viewWithTag:1];
        [btnLeaveGroup setTitle:@"Leave Group" forState:UIControlStateNormal];
        [btnLeaveGroup addTarget:self action:@selector(leaveGroup:) forControlEvents:UIControlEventTouchUpInside];
        btnLeaveGroup.layer.shadowColor = [UIColor grayColor].CGColor;
        btnLeaveGroup.layer.shadowOpacity = 0.5;
        btnLeaveGroup.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [btnLeaveGroup.layer setMasksToBounds:YES];
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //get the name and the id
    if(indexPath.section == 0){
        //set selected index or trail type id
        Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
        
        EventDetailVC *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"event_details"];
        listViewController.eventId = [event event_id];
        listViewController.eventName = [event name];
        
        [self.navigationController pushViewController:listViewController animated:YES];
    }
}

- (IBAction)leaveGroup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = appDelegate.userDetails;
    NSString *post =[[NSString alloc] initWithFormat:@"api=leave_group&user_id=%@&group_id=%@", currentUser.user_id, _selectedGroup.group_id];
    NSURL *url = [NSURL URLWithString:@"http://iqmicrosystems.com/groupay/v1/api.php?"];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:kNilOptions timeoutInterval:20];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [urlRequest setURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:postData];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    if(responseData && !error) {
        NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseString);
        NSError *error = nil;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        if([[responseDictionary allKeys] count] > 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success !" message:@"Group left successfully !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
