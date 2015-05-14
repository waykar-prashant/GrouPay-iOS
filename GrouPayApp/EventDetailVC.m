//
//  EventDetailVC.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "EventDetailVC.h"
#import "User.h"
#import "AppDelegate.h"
#import "PaymentViewController.h"


AppDelegate *appDel;
@interface EventDetailVC ()

@end

NSString *eName;
NSString *eStartTime;
NSString *eEndTime;
NSString *eDesc;
NSNumber *eFee;


@implementation EventDetailVC
@synthesize eventId, eventName, eventDesc, eventFee, youPaid, memberArray, myLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.eventName;
    owes = [[NSMutableArray alloc] init];
    NSLog(@"Event Details VC %@", eventId);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    memberArray = [[NSMutableArray alloc] init];
    appDel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchEventDetails];
}

- (void)fetchEventDetails {
    NSString *post =[[NSString alloc] initWithFormat:@"api=get_event_details&event_id=%@", eventId];
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
            
            /*NSDictionary *jsonData = [NSJSONSerialization
             JSONObjectWithData:urlData
             options:NSJSONReadingMutableContainers
             error:&error];
             NSLog(@"JSON DATA :%@ ", jsonData);
             //[self setUserDetails:jsonData];
             success = [jsonData[@"group_id"] integerValue];*/
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSString *admin_id = [jsonData objectForKey:@"creator_id"];
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            User *currentUser = appDelegate.userDetails;
            
            if([currentUser.user_id isEqualToString:admin_id])
                _isAdmin = YES;
            
            NSLog(@"Event Details : %@", jsonData);
            eName = [jsonData valueForKey:@"name"];
            eStartTime = [jsonData valueForKey:@"start_time"];
            eEndTime = [jsonData valueForKey:@"end_time"];
            eDesc = [jsonData valueForKey:@"description"];
            eFee = [jsonData valueForKey:@"fee"];
            eName = [jsonData valueForKey:@"name"];
            
            
            
            [memberArray removeAllObjects];
            /*NSArray *eventArray = [jsonData valueForKey:@"1"];
            //event_id, name, description, start_time, end_time, creator_id, fee
            for(int i = 0; i < [eventArray count]; i++){
                //[[[jsonData valueForKey:@"1"] objectAtIndex:i] valueForKey:@"name"]
                NSString *eventName = [[eventArray objectAtIndex:i] valueForKey:@"name"];
                NSString *eventId = [[eventArray objectAtIndex:i] valueForKey:@"event_id"];
                NSString *description = [[eventArray objectAtIndex:i] valueForKey:@"description"];
                NSString *startTime = [[eventArray objectAtIndex:i] valueForKey:@"start_time"];
                NSString *endTime = [[eventArray objectAtIndex:i] valueForKey:@"end_time"];
                NSString *creatorId = [[eventArray objectAtIndex:i] valueForKey:@"creator_id"];
                NSString *fee = [[eventArray objectAtIndex:i] valueForKey:@"fee"];
                Event *event = [[Event alloc] init];
                [event setName:eventName];
                [event setEvent_id:eventId];
                [event setDescription:description];
                [event setStart_time:startTime];
                [event setEnd_time:endTime];
                [event setCreator_id:creatorId];
                [event setFee:fee];
                [[self eventArray] addObject:event];
            }*/
            
            NSArray *userArray = [jsonData valueForKey:@"0"];
            //user_id, name, email, phone_no, password
            for(int i = 0; i < [userArray count]; i++){
                //[[[jsonData valueForKey:@"1"] objectAtIndex:i] valueForKey:@"name"]
                NSString *name = [[userArray objectAtIndex:i] valueForKey:@"name"];
                NSString *userId = [[userArray objectAtIndex:i] valueForKey:@"user_id"];
                NSString *email = [[userArray objectAtIndex:i] valueForKey:@"email"];
                
                NSString *status = [[userArray objectAtIndex:i] valueForKey:@"status"];
                NSString *paid = [[userArray objectAtIndex:i] valueForKey:@"paid"];
                
                User *user = [[User alloc] init];
                [user setName:name];
                [user setUser_id:userId];
                [user setEmail:email];
                [user setStatus:status];
                [user setPaid:paid];
                
                [[self memberArray] addObject:user];
                
                if([[[userArray objectAtIndex:i] valueForKey:@"paid"] integerValue] < [[jsonData valueForKey:@"fee"] integerValue]) {
                    user.owed_amount = [NSString stringWithFormat:@"%ld", [[jsonData valueForKey:@"fee"] integerValue] - [[[userArray objectAtIndex:i] valueForKey:@"paid"] integerValue]];
                    [owes addObject:user];
                }
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
    if(!_isAdmin)
        return 3;
    else
        return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
        return 5;
    }else if (section == 1){
        return [memberArray count];
    }
    else if (section == 2)
        return 1;
    else
        return 1;
    return 0;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Event Information";
    }else if(section == 1){
        return @"Event Members";
    }
    else if (section == 2)
        return @"Send Payment Reminders";
    else
        return @"Leave Event";
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
    }
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    //name, description, start_time, end_time, creator_id, fee,
    if(indexPath.section == 0){
        
        if(indexPath.row ==0){
            cell.textLabel.text = @"Event Name : ";
            cell.detailTextLabel.text = eName;
           
            //myLabel.text = eventName;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Description : ";
            cell.detailTextLabel.text = eDesc;
            //myLabel.text = eventDesc;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Start Time : ";
            //myLabel.text = @"08-12-2015";
             cell.detailTextLabel.text = eStartTime;
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"End Time : ";
             cell.detailTextLabel.text = eEndTime;
            //myLabel.text =  @"08-12-2015";
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"Fee : ";
             cell.detailTextLabel.text = eFee;
           // myLabel.text = eventFee;
        }
        cell.detailTextLabel.textColor = [UIColor grayColor];
        //cell.detailTextLabel.font = [UIFont systemFontOfSize:17];
        cell.textLabel.textColor = [UIColor redColor];
        //cell.textLabel.font = [UIFont systemFontOfSize:21];
        //Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
        
        //cell.textLabel.text = [event name];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1) {
        
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        /*if([appDel userDetails].user_id == user.user_id){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }*/
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.text = [user name];
        NSString *numStr;
        if([[user paid] integerValue] < [eFee integerValue]){
            numStr = [NSString stringWithFormat:@" : You Owe To Event   $%@",[[NSNumber numberWithFloat:([eFee floatValue] - [[user paid] floatValue])] stringValue]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor redColor];
            
        }else if([[user paid] integerValue] > [eFee integerValue]){
            numStr = [NSString stringWithFormat:@" : You Get Back   $%@",[[NSNumber numberWithFloat:([eFee floatValue] - [[user paid] floatValue])] stringValue]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor greenColor];
            
        }else if([[user paid] integerValue] == [eFee integerValue]){
            numStr = @" : Settled Up";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            //cell.textLabel.textColor = [UIColor grayColor];
        }
        cell.detailTextLabel.text = numStr;
        NSLog(@"U1 : %@  -- %@", [appDel userDetails].user_id, user.user_id );
       
    }
    else if(indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaveEventCell"];
        UIButton *btnLeaveGroup = (UIButton *)[cell viewWithTag:1];
        [btnLeaveGroup setTitle:@"Send Payment Reminder" forState:UIControlStateNormal];
        [btnLeaveGroup addTarget:self action:@selector(sendPaymentReminder:) forControlEvents:UIControlEventTouchUpInside];
        btnLeaveGroup.layer.shadowColor = [UIColor grayColor].CGColor;
        btnLeaveGroup.layer.shadowOpacity = 0.5;
        btnLeaveGroup.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        [btnLeaveGroup.layer setMasksToBounds:YES];
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaveEventCell"];
        UIButton *btnLeaveGroup = (UIButton *)[cell viewWithTag:1];
        [btnLeaveGroup setTitle:@"Leave Event" forState:UIControlStateNormal];
        [btnLeaveGroup addTarget:self action:@selector(leaveEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    if(indexPath.section == 1){
        //set selected index or trail type id
        
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];
        if([[appDel userDetails].user_id isEqualToString:user.user_id]){
            NSLog(@"working");
            PaymentViewController *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"payment"];
            [listViewController setTitle:eventName];
            listViewController.eventId = eventId;
            listViewController.userId = user.user_id;
            //uid, eventid, amt
            
            /*Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
            
            EventDetailVC *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"event_details"];
            listViewController.eventId = [event event_id];
            listViewController.eventName = [event name];
            */
            [self.navigationController pushViewController:listViewController animated:YES];
        } else{
            //cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (IBAction)sendPaymentReminder:(id)sender {
    UserGroupsViewController *userGroupsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserGroupsViewController"];
    userGroupsVC.debts = owes;
    userGroupsVC.eventName = eName;
    [self.navigationController pushViewController:userGroupsVC animated:YES];
}

- (IBAction)leaveEvent:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = appDelegate.userDetails;
    NSString *post =[[NSString alloc] initWithFormat:@"api=leave_event&user_id=%@&event_id=%@", currentUser.user_id, self.eventId];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success !" message:@"Event left successfully !" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
