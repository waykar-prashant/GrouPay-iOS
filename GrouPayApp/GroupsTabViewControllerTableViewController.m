//
//  GroupsTabViewControllerTableViewController.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "GroupsTabViewControllerTableViewController.h"
#import "CreateNewGroupVC.h"
#import "Group.h"
#import "GroupDetailVC.h"
#import "HttpUtil.h"
//#import "AppDelegate.h"


NSDictionary *jsonData1;
//AppDelegate *appDelegate;
@interface GroupsTabViewControllerTableViewController ()

@property(nonatomic,strong) CreateNewGroupVC *addController;

@end

@implementation GroupsTabViewControllerTableViewController
@synthesize groupsArray, addController;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Groups";

    UIBarButtonItem *addGroup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    
    NSArray *actionButtonItems = @[addGroup];
    self.navigationItem.rightBarButtonItems = actionButtonItems;

//    UIBarButtonItem* rightNavButton=[[UIBarButtonItem alloc] initWithTitle:@"logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
//    self.navigationItem.leftBarButtonItem =rightNavButton ;
    

    //self.navigationItem.rightBarButtonItem = yourButton;
    //[yourButton release];
    //Load all the created Groups and Display them
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    jsonData1 = [self performSelector:@selector(fetchDataFromUrl) withObject:nil];
    
    groupsArray = [[NSMutableArray alloc] init];
    for (NSArray *arr in jsonData1) {
        NSLog(@"Each Array : %@", [arr valueForKey:@"group_id"]);
        Group *group = [[Group alloc] init];
        [group setName:[arr valueForKey:@"name"]];
        [group setGroup_id:[arr valueForKey:@"group_id"]];
        [group setAdmin_id:[arr valueForKey:@"admin_id"]];
        [group setCreated_date:[arr valueForKey:@"created_date"]];
        //[[AppDelegate getGlobalGroups] addObject:group];
        [[self groupsArray] addObject:group];
    }
    [self.tableView reloadData];
}

- (NSDictionary *) fetchDataFromUrl{
    //v1/api.php?api=get_user_groups&user_id=101
    //get all the groups
    NSString *parameters = [NSString stringWithFormat:@"api=get_user_groups&user_id=101"];
    NSDictionary *json = [HttpUtil fetchJsonDataFromUrl:parameters];
    return json;
}

-(void) logout{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"on completion");
    }];
}

-(IBAction)addGroup:(id)sender
{
    NSLog(@"Add new group");
    //Push Modal Screen for adding a new Group
    addController = [self.storyboard instantiateViewControllerWithIdentifier:@"create_group"];
    addController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void) addGroupName:(NSString *)strName andGroupId:(NSString *) strGroupId
{
    Group *group = [[Group alloc] init];
    [group setName:strName];
    [group setGroup_id:strGroupId];
    //[[AppDelegate getGlobalGroups] addObject:group];
    [groupsArray addObject:group];
    [self.tableView reloadData];
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
    //return [[AppDelegate getGlobalGroups] count];
    return [groupsArray count];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Group *group = [groupsArray objectAtIndex:indexPath.row];
    NSLog(@"Group Name : %@", [group name]);
    //Group *group = [[AppDelegate getGlobalGroups] objectAtIndex:indexPath.row];//[groupsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [group name];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    Group *group = [groupsArray objectAtIndex:indexPath.row];
    GroupDetailVC *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"group_detail"];
    detailViewController.title = [group name];
    detailViewController.selectedGroup = group;
    //NSDictionary *dictTemp = [arrItems objectAtIndex:indexPath.row];
    //detailViewController.strDesc = [dictTemp objectForKey:@"Desc"];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        Group *group = [groupsArray objectAtIndex:indexPath.row];
//        NSString *post =[[NSString alloc] initWithFormat:@"api=delete_group&group_id=%@", group.group_id];
//        NSURL *url = [NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"];
//        NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:kNilOptions timeoutInterval:20];
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
//        [urlRequest setURL:url];
//        [urlRequest setHTTPMethod:@"POST"];
//        [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [urlRequest setHTTPBody:postData];
//        NSURLResponse *response = nil;
//        NSError *error = nil;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
//            if(responseData && !error) {
//                NSString *responseString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
//                NSLog(@"%@", responseString);
//                NSError *error = nil;
//                NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
//                if([[responseDictionary allKeys] count] > 0) {
//                    [groupsArray removeObjectAtIndex:indexPath.row];
//                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                }
//            }
//            else {
//            }
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}

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
