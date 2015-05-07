//
//  HttpUtil.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpUtil : NSObject
+ (Boolean *) checkLogin: (NSString *) email with: (NSString *) password;
+ (NSDictionary *) createGroup: (NSString *) user_id with: (NSString *) groupName;

+ (Boolean) registerUser: (NSString *) email with: (NSString *) password par2: (NSString *) name par3: (NSString *) phone;
+ (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag;
+ (void) setUserDetails:(NSDictionary *) userDictionary;
+ (NSDictionary *) fetchJsonDataFromUrl: (NSString *) parameters;

//extern NSString * const apiURL;
@end
