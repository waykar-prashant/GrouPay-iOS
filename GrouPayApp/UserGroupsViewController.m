//
//  UserGroupsViewController.m
//  GrouPayApp
//
//  Created by Prashant Waykar on 14/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "UserGroupsViewController.h"

@interface UserGroupsViewController ()

@end

@implementation UserGroupsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Payment Reminders";
    
    //_btnSendReminders.layer.cornerRadius = 3.0f;
//    _btnSendReminders.layer.masksToBounds = YES;
    
    recipients = [[NSMutableArray alloc] init];
    body = [[NSMutableString alloc] init];
    [_btnSendReminders setTitle:@"Send Payment Reminders" forState:UIControlStateNormal];
    _btnSendReminders.layer.shadowColor = [UIColor grayColor].CGColor;
    _btnSendReminders.layer.shadowOpacity = 0.5;
    _btnSendReminders.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    [_btnSendReminders.layer setMasksToBounds:YES];
    
    if([_debts count] > 0)
       [_btnSendReminders setEnabled:YES];
    else
        [_btnSendReminders setEnabled:NO];
    [body appendString:[NSString stringWithFormat:@"The amounts due for the %@ event are : \n\n", _eventName]];
    for (User *user in _debts) {
        [recipients addObject:user.email];
        NSString *str = [NSString stringWithFormat:@"%@ : %@\n", user.name, user.owed_amount];
        [body appendString:str];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_debts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupCell" forIndexPath:indexPath];
    User *user = [_debts objectAtIndex:indexPath.row];
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = user.owed_amount;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.transform = CGAffineTransformMakeTranslation(cell.bounds.size.width * 1, 0);
    [UIView animateWithDuration:((indexPath.row + 5) * 0.10) animations:^{
        cell.transform = CGAffineTransformIdentity;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [_groupsTable reloadData];
            break;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendReminders:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeVC = [[MFMailComposeViewController alloc] init];
        [mailComposeVC setMailComposeDelegate:self];
        [mailComposeVC setToRecipients:recipients];
        [mailComposeVC setSubject:[NSString stringWithFormat:@"Payment reminder for %@ on GrouPay", _eventName]];
        [mailComposeVC setMessageBody:body isHTML:NO];
        [self.navigationController presentViewController:mailComposeVC animated:YES completion:nil];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"No mail account configured ! Please configure one via settings" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}
@end
