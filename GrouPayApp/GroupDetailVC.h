//
//  GroupDetailVC.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddEventViewController.h"
#import "Group.h"

@interface GroupDetailVC : UITableViewController
@property (nonatomic, retain) Group *selectedGroup;
@property (nonatomic, retain) NSMutableArray *eventArray;
@property (nonatomic, retain) NSMutableArray *memberArray;

@end
