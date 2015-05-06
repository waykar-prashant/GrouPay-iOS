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


@interface GroupsTabViewControllerTableViewController ()

@property(nonatomic,strong) CreateNewGroupVC *addController;

@end

@implementation GroupsTabViewControllerTableViewController
@synthesize groupsArray, addController;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Groups";
    /*UIBarButtonItem *yourButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Your Button"
                                   style:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(methodName:)];
    */
    //self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
    
    UIBarButtonItem *addGroup = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGroup:)];
    
    NSArray *actionButtonItems = @[addGroup];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    groupsArray = [[NSMutableArray alloc] init];
    Group *group = [[Group alloc] init];
    [group setName:@"Group Name 1"];
    [group setGroup_id:@"1"];
    [group setAdmin_id:@"1"];
    [group setCreated_date:@"12-5-2015"];
    
    Group *group2= [[Group alloc] init];
    [group2 setName:@"Group Name 2"];
    [group2 setGroup_id:@"2"];
    [group2 setAdmin_id:@"2"];
    [group2 setCreated_date:@"12-5-2015"];
    
    Group *group1 = [[Group alloc] init];
    [group1 setName:@"Group Name 3"];
    [group1 setGroup_id:@"3"];
    [group1 setAdmin_id:@"3"];
    [group1 setCreated_date:@"12-5-2015"];
    [groupsArray addObject:group];
    [groupsArray addObject:group1];
    [groupsArray addObject:group2];
    
    
    
    
    
    
    //self.navigationItem.rightBarButtonItem = yourButton;
    //[yourButton release];
    //Load all the created Groups and Display them
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [groupsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Group *group = [groupsArray objectAtIndex:indexPath.row];
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
    //NSDictionary *dictTemp = [arrItems objectAtIndex:indexPath.row];
    //detailViewController.strDesc = [dictTemp objectForKey:@"Desc"];
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
