//
//  SettingsTableViewController.m
//  GrouPayApp
//
//  Created by Salil Shahane on 12/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titles = @[@"Share", @"Logout"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0: {
            UIActionSheet *shareActionSheet = [[UIActionSheet alloc] initWithTitle:@"Share" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"via e-mail", @"via SMS", nil];
            [shareActionSheet showInView:self.view];
            break;
        }
        case 1:
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"on completion");
            }];
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            //email
            if([MFMailComposeViewController canSendMail]) {
                MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
                [mailComposeVC setMailComposeDelegate:self];
                [mailComposeVC setMessageBody:@"https://www.google.com" isHTML:NO];
                [self.navigationController presentViewController:mailComposeVC animated:YES completion:nil];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"No mail account configured ! Please configure one via settings" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
            break;
        }
        case 1: {
            if([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *messageComposeVC = [[MFMessageComposeViewController alloc] init];
                [messageComposeVC setMessageComposeDelegate:self];
                [messageComposeVC setBody:@"https://www.google.com"];
                [self.navigationController presentViewController:messageComposeVC animated:YES completion:nil];
                //sms
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Cannot share using current device" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertView show];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - MFMailComposeViewController Delegates

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
        default:
            break;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewController Delegates

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultSent:
            break;
        case MessageComposeResultFailed:
        default:
            break;
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
