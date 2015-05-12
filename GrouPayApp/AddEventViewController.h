//
//  AddEventViewController.h
//  GrouPayApp
//
//  Created by Salil Shahane on 11/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Group.h"

@interface AddEventViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *addEventTableView;
@property (strong, nonatomic) NSArray *titles;
@property (strong, nonatomic) NSString *strEventName, *strEventDescription, *strStartTime, *strEndTime, *strFee, *group_id, *creator_id;
@property (strong, nonatomic) Group *selectedGroup;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end
