//
//  User.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    NSString *name;
    NSString *email;
    NSString *password;
    NSString *phone;
    NSString *user_id;
    NSNumber *paid;
    NSString *status;
    
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *status;
@property (nonatomic, retain) NSString *owed_amount;
@property (nonatomic, retain) NSNumber *paid;





@end