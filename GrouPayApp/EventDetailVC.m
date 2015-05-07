//
//  EventDetailVC.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "EventDetailVC.h"

@interface EventDetailVC ()

@end

@implementation EventDetailVC
@synthesize eventId, eventName, eventDesc, eventFee, youPaid, memberArray, myLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        return 6;
    }else if (section == 1){
        return [memberArray count];
    }
    return 0;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"Event Information";
    }else if(section == 1){
        return @"Event Members";
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
    //name, description, start_time, end_time, creator_id, fee,
    if(indexPath.section == 0){
        if(indexPath.row ==0){
            cell.textLabel.text = @"Event Name : ";
            myLabel.text = eventName;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"Description : ";
            myLabel.text = eventDesc;
        }else if(indexPath.row == 2){
            cell.textLabel.text = @"Start Time : ";
            myLabel.text = @"08-12-2015";
        }else if(indexPath.row == 3){
            cell.textLabel.text = @"End Time : ";
            myLabel.text =  @"08-12-2015";
        }else if(indexPath.row == 4){
            cell.textLabel.text = @"Fee : ";
            myLabel.text = eventFee;
        }
        //Event *event = (Event *)[eventArray objectAtIndex:indexPath.row];
        
        //cell.textLabel.text = [event name];
        //cell.accessoryType = UITableViewCellAccessoryNone;
    }else if (indexPath.section == 1) {
        User *user = (User *)[memberArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [user name];
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
