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
    [self fetchGroups];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchGroups {
    NSString *post =[[NSString alloc] initWithFormat:@"api=get_group_info&group_id=16"];
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
            NSArray *eventArray = [jsonData valueForKey:@"1"];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
        return [eventArray count];
    }else if (section == 1){
        return [memberArray count];
    }
    return 0;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"My Events";
    }else if(section == 1){
        return @"Group Members";
    }
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
    if(indexPath.section == 0){
        Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [event name];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1) {
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];

        cell.textLabel.text = [user name];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
