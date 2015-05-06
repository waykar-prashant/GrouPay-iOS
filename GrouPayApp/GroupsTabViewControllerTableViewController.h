//
//  GroupsTabViewControllerTableViewController.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateNewGroupVC.h"

@interface GroupsTabViewControllerTableViewController : UITableViewController<SPTAddArticleDelegate>

@property (nonatomic, retain) NSMutableArray *groupsArray;

@end
