//
//  SettingsTableViewController.h
//  GrouPayApp
//
//  Created by Salil Shahane on 12/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsTableViewController : UITableViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
    NSArray *titles;
}

@end
