//
//  EventDetailVC.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailVC : UITableViewController
@property (nonatomic, retain) NSString *eventId;
@property (nonatomic, retain) NSString *eventName;
@property (nonatomic, retain) NSString *eventDesc;
@property (nonatomic, retain) NSString *eventFee;
@property (nonatomic, retain) NSString *youPaid;
@property (nonatomic, retain) NSMutableArray *memberArray;

@end
