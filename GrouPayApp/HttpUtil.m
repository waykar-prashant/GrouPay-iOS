//
//  HttpUtil.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "HttpUtil.h"
#import "AppDelegate.h"
#import "User.h"


AppDelegate *appDelegate;


@implementation HttpUtil
//NSString * const apiURL = @"http://www.iqmicrosystems.com/groupay/v1/api.php?";


+ (NSDictionary *) fetchJsonDataFromUrl: (NSString *) parameters{
    //fetch json data
    NSLog(@"submit fetch data from url");
    @try {
        
        NSString *post = [[NSString alloc] initWithFormat:parameters];
        NSLog(@"PostData: %@",post);
        
        NSURL *url = [NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"
                      ];
        
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        if ([response statusCode] >= 200 && [response statusCode] < 300)
        {
            NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(@"Response ==> %@", responseData);
            
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization
                                      JSONObjectWithData:urlData
                                      options:NSJSONReadingMutableContainers
                                      error:&error];
            return jsonData;
            
        } else {
            //if (error) NSLog(@"Error: %@", error);
            [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
            return nil;
        }
        return nil;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    
    return nil;
    
}

+(Boolean *) checkLogin:(NSString *)email with:(NSString *)password{
    
    NSInteger success = -1;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // return TRUE;
    @try {
        
        if([email isEqualToString:@""] || [password isEqualToString:@""] ) {
            [self alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"api=login&email=%@&password=%@", email, password];
            NSLog(@"PostData: %@",post);
            //v1/api.php?api=login&email=surbhi.sharma@sjsu.edu&password=abc
            NSURL *url=[NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                NSLog(@"JSON DATA :%@ ", jsonData);
                
                success = [jsonData[@"user_id"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success >= 1)
                {
                    [self setUserDetails:jsonData];
                    NSString *uid = jsonData[@"user_id"];
                    //[appDelegate setUID:uid];
                    return TRUE;
                    NSLog(@"Login SUCCESS-----UID %@ --", uid);
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Sign in Failed!" :0];
                    return FALSE;
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Sign in Failed!" :0];
                return FALSE;
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    
    return FALSE;
}

+(Boolean) registerUser:(NSString *)email with:(NSString *)password par2:(NSString *)name par3:(NSString *) phone{
    Boolean success = false;
    @try {
        
        if([email isEqualToString:@""] || [password isEqualToString:@""] ) {
            NSLog(@"Pease enter email and password");
            //[appDelegate alertStatus:@"Please enter Email and Password" :@"Sign in Failed!" :0];
        } else {
            //v1/api.php?api=register&name=Surbhi&email=surbhi.sharma@sjsu.edu&phone_no=408-334-6520&password=abc
            
            
            NSString *post =[[NSString alloc] initWithFormat:@"api=register&name=%@&email=%@&password=%@&phone=%@", name, email, password, phone];
            NSLog(@"PostData: %@",post);
            
            NSURL *url=[NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"];
            
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                [self setUserDetails:jsonData];
                //[self alertStatus:@"Registration" :@"Successfull!" :0];
                //success = [jsonData[@"user_id"] integerValue];
                NSLog(@"User ID : %@", jsonData[@"user_id"]);
                //NSLog(@"Success: %ld",(long)success);
                success = true;
                /*if(success >= 1)
                 {
                 NSLog(@"Login SUCCESS");
                 [AppDelegate alertStatus:error_msg :@"Registered SUccessfully" :0];
                 } else {
                 
                 NSString *error_msg = (NSString *) jsonData[@"error_message"];
                 [AppDelegate alertStatus:error_msg :@"Sign in Failed!" :0];
                 }*/
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                success = false;
                [self alertStatus:@"Registration" :@"Registration Failed!" :0];
            }
            
        }
        return success;
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Sign in Failed." :@"Error!" :0];
    }
    
}




+(NSDictionary *) createGroup:(NSString *)user_id with:(NSString *)groupName
{
    NSInteger success = -1;
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    @try {
        
        if([user_id isEqualToString:@""] || [groupName isEqualToString:@""] ) {
            [self alertStatus:@"Please enter a group name " :@"Creation of Group Failed!" :0];
        } else {
            NSString *post =[[NSString alloc] initWithFormat:@"api=create_group&user_id=%@&name=%@", user_id, groupName];
            NSLog(@"PostData: %@",post);
            //v1/api.php?api=login&email=surbhi.sharma@sjsu.edu&password=abc
            NSURL *url=[NSURL URLWithString:@"http://www.iqmicrosystems.com/groupay/v1/api.php?"];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            
            //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
            
            NSError *error = [[NSError alloc] init];
            NSHTTPURLResponse *response = nil;
            NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSLog(@"Response code: %ld", (long)[response statusCode]);
            
            if ([response statusCode] >= 200 && [response statusCode] < 300)
            {
                NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
                NSLog(@"Response ==> %@", responseData);
                
                NSError *error = nil;
                NSDictionary *jsonData = [NSJSONSerialization
                                          JSONObjectWithData:urlData
                                          options:NSJSONReadingMutableContainers
                                          error:&error];
                NSLog(@"JSON DATA :%@ ", jsonData);
                //[self setUserDetails:jsonData];
                success = [jsonData[@"group_id"] integerValue];
                NSLog(@"Success: %ld",(long)success);
                
                if(success >= 1)
                {
                    //NSString *uid = jsonData[@"user_id"];
                    //[appDelegate setUID:uid];
                    
                    NSLog(@"created gorup SUCCESS-----UID %@ --", success);
                    return jsonData;
                } else {
                    
                    NSString *error_msg = (NSString *) jsonData[@"error_message"];
                    [self alertStatus:error_msg :@"Group Creation Failed!" :0];
                    return nil;
                    
                }
                
            } else {
                //if (error) NSLog(@"Error: %@", error);
                [self alertStatus:@"Connection Failed" :@"Group Creation Failed!" :0];
                return nil;
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        [self alertStatus:@"Group Creation Failed." :@"Error!" :0];
    }
    
    return nil;
}

+(void) setUserDetails:(NSDictionary *) userDictionary {
    appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *name = userDictionary[@"name"];
    NSString *user_id = userDictionary[@"user_id"];
    NSString *email = userDictionary[@"email"];
    NSString *phone = userDictionary[@"phone"];
    NSString *password = userDictionary[@"password"];
    User *user = [[User alloc] init];
    [user setName:name];
    [user setUser_id:user_id];
    [user setEmail:email];
    [user setPhone:phone];
    [user setPassword:password];
    [appDelegate setUserDetails:user];
    NSLog(@"User Name : %@", name);
    
}

+ (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil, nil];
    alertView.tag = tag;
    [alertView show];
}



@end
