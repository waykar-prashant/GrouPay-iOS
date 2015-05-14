//
//  UserGroupsViewController.h
//  GrouPayApp
//
//  Created by Prashant Waykar on 14/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"
#import <MessageUI/MessageUI.h>

@interface UserGroupsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate> {
    NSMutableArray *recipients;
    NSMutableString *body;
}
@property (weak, nonatomic) IBOutlet UITableView *groupsTable;
@property (strong, nonatomic) NSArray *debts;
@property (strong, nonatomic) NSString *eventName;
- (IBAction)sendReminders:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSendReminders;
@end
