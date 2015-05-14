//
//  AddEventViewController.m
//  GrouPayApp
//
//  Created by Prashant Waykar on 11/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "AddEventViewController.h"
#import "GPNetworkingManager.h"
#import "AppDelegate.h"
#import "User.h"
#define baseURL @"http://www.iqmicrosystems.com/groupay/v1/api.php?"

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Add Event";
    _titles = @[@"Event Name", @"Description", @"Start Time", @"End Time", @"Fee"];
    
    UIBarButtonItem *btnSaveEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEvent:)];
    [self.navigationItem setRightBarButtonItem:btnSaveEvent];
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    // Do any additional setup after loading the view.
}

- (BOOL)validateUserInput {
    if([_strEventName length] > 0 &&
       [_strEventDescription length] > 0 &&
       [_strStartTime length] > 0 &&
       [_strEndTime length] > 0 &&
       [_strFee length] > 0)
        return YES;
    else
        return NO;
}

- (IBAction)saveEvent:(id)sender {
    [self.view endEditing:YES];
    
    if([self validateUserInput]) {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = appDelegate.userDetails;
    
    NSString *post =[[NSString alloc] initWithFormat:@"api=create_event&group_id=%@&name=%@&description=%@&start_time=%@&end_time=%@&creator_id=%@&fee=%@", _selectedGroup.group_id, _strEventName, _strEventDescription, _strStartTime, _strEndTime, currentUser.user_id, _strFee];
    NSURL *url = [NSURL URLWithString:baseURL];
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
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error !" message:@"Please enter all the fields to add a new event !" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickCell" forIndexPath:indexPath];
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
        lbl1.text = [_titles objectAtIndex:indexPath.row];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
        lbl2.text = _strStartTime;
        return cell;
    }
    else if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickCell" forIndexPath:indexPath];
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
        lbl1.text = [_titles objectAtIndex:indexPath.row];
        UILabel *lbl2 = (UILabel *)[cell viewWithTag:2];
        lbl2.text = _strEndTime;
        return cell;

    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addEventCell" forIndexPath:indexPath];
        UILabel *lbl1 = (UILabel *)[cell viewWithTag:1];
        UITextField *txtField = (UITextField *)[cell viewWithTag:2];
        txtField.tag = indexPath.row;
        lbl1.text = [_titles objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 2) {
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.datePicker.tag = 1;
            self.datePickerView.frame = CGRectMake(0, (self.view.bounds.size.height - self.datePickerView.bounds.size.height) - 50, self.view.bounds.size.width, self.datePickerView.bounds.size.height);
        } completion:^(BOOL finished) {
            
        }];
    }
    else if(indexPath.row == 3) {
        [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.datePicker.tag = 2;
            self.datePickerView.frame = CGRectMake(0, (self.view.bounds.size.height - self.datePickerView.bounds.size.height) - 50, self.view.bounds.size.width, self.datePickerView.bounds.size.height);
        } completion:^(BOOL finished) {
            [_addEventTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            _strEventName = textField.text;
            break;
        case 1:
            _strEventDescription = textField.text;
            break;
        case 2:
            _strStartTime = [self stringFromDate:[[NSDate alloc] init]];
            break;
        case 3:
            _strEndTime = [self stringFromDate:[[NSDate alloc] init]];
            break;
        case 4:
            _strFee = textField.text;
            break;
        default:
            break;
    }
}

- (NSString *)stringFromDate:(NSDate *)date {
    return nil;
}

- (IBAction)datePickerViewDonePressed:(id)sender {
    
    //NSIndexPath *indexPath = [_addEventTableView indexPathForSelectedRow];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strTime = [dateFormatter stringFromDate:self.datePicker.date];
    if(self.datePicker.tag == 1)
        _strStartTime = strTime;
    else
        _strEndTime = strTime;
    
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.datePickerView.frame = CGRectMake(0, 700, self.view.bounds.size.width, self.datePickerView.bounds.size.height);
    } completion:^(BOOL finished) {
        [_addEventTableView reloadData];
    }];
}

- (IBAction)datePickerCancelPressed:(id)sender {
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.datePickerView.frame = CGRectMake(0, 700, self.view.bounds.size.width, self.datePickerView.bounds.size.height);
    } completion:^(BOOL finished) {
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
