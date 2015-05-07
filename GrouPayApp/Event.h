//
//  Event.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject
//event_id, name, description, start_time, end_time, creator_id, fee
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *event_id;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *start_time;
@property (nonatomic, retain) NSString *end_time;
@property (nonatomic, retain) NSString *creator_id;
@property (nonatomic, retain) NSString *fee;

@end
