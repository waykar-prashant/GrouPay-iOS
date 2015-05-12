//
//  AddEventViewController.m
//  GrouPayApp
//
//  Created by Salil Shahane on 11/05/15.
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
    _titles = @[@"Event Name", @"Description", @"Start Time", @"End Time", @"Fee"];
    
    UIBarButtonItem *btnSaveEvent = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveEvent:)];
    [self.navigationItem setRightBarButtonItem:btnSaveEvent];
    [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    // Do any additional setup after loading the view.
}

- (IBAction)saveEvent:(id)sender {
    [self.view endEditing:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User *currentUser = appDelegate.userDetails;
    
//    NSDictionary *parameters = @{@"group_id":_selectedGroup.group_id,
//                                 @"name":_selectedGroup.name,
//                                 @"description":_strEventDescription,
//                                 @"start_time":_strStartTime,
//                                 @"end_time":_strEndTime,
//                                 @"creator_id":currentUser.user_id,
//                                 @"fee":_strFee};
//    [GPNetworkingManager sendRequestWithURLString:@"v1/api.php?api=create_event" parameters:parameters completionHandler:^(NSError *error, NSDictionary *responseDictionary) {
//        
//    }];
    
    NSString *post =[[NSString alloc] initWithFormat:@"api=create_event&userid=%@&group_id=%@&name=%@&description=%@&start_time=%@&end_time=%@&admin_id=%@&fee=%@", currentUser.user_id, _selectedGroup.group_id, _selectedGroup.name, _strEventDescription, _strStartTime, _strEndTime, currentUser.user_id, _strFee];
    NSURL *url = [NSURL URLWithString:baseURL];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:kNilOptions timeoutInterval:20];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data && !connectionError) {
            NSString *responseData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseData);
            NSError *error = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        }
        else {
        }
    }];

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
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm a"];
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
