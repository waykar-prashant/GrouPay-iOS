//
//  MyGroupayVC.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "MyGroupayVC.h"
#import "AppDelegate.h"
@interface MyGroupayVC ()

@end
AppDelegate *appDel1;
@implementation MyGroupayVC
@synthesize memberArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    memberArray = [[NSMutableArray alloc] init];
    appDel1 = (AppDelegate *)[UIApplication sharedApplication].delegate;
    insertIndexPaths = [[NSMutableArray alloc] init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Event Details";
    }else if(section == 1){
        return @"Event Members";
    }
    return @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchGroups];
}

- (void)fetchGroups {
    NSString *post =[[NSString alloc] initWithFormat:@"api=get_expenses&user_id=%@", [appDel1 userDetails].user_id];
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
            NSArray *userArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"JSON DATA %@", userArray);
            [memberArray removeAllObjects];
            for (int i = 0; i < [userArray count]; i++) {
                NSString *name = [[userArray objectAtIndex:i] valueForKey:@"name"];
                NSString *eventId = [[userArray objectAtIndex:i] valueForKey:@"event_id"];
                NSString *balance = [[userArray objectAtIndex:i] valueForKey:@"balance"];
                User *user = [[User alloc] init];
                [user setName:name];
                [user setUser_id:eventId];
                [user setEmail:balance];
                [[self memberArray] addObject:user];
                
                // NSString *balance = [[userArray objectAtIndex:i] valueForKey:@"balance"];
            }
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
            }*/
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [memberArray count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeTranslation(cell.bounds.size.width * 1, 0);
    [UIView animateWithDuration:((indexPath.row + 5) * 0.10) animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [user name];
        NSString *srt = [NSString stringWithFormat:@"%@", [user email]];
        cell.detailTextLabel.text = srt;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
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
