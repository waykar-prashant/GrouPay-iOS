//
//  GPNetworkingManager.m
//  GrouPayApp
//
//  Created by Prashant Waykar on 11/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "GPNetworkingManager.h"
#define baseURL @"http://www.iqmicrosystems.com/groupay/v1/api.php?"

@implementation GPNetworkingManager

+ (void)sendRequestWithURLString:(NSString *)urlStr parameters:(NSDictionary *)parameters completionHandler:(void (^) (NSError *error, NSDictionary *responseDictionary))completionHandler {
    
    NSURL *url = [NSURL URLWithString:[baseURL stringByAppendingString:urlStr]];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:kNilOptions timeoutInterval:20];
    NSData *postData = [NSKeyedArchiver archivedDataWithRootObject:parameters];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(data && !connectionError) {
            NSString *responseData = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responseData);
            NSError *error = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            completionHandler(nil, responseDictionary);
        }
        else {
            completionHandler(connectionError, nil);
        }
    }];
}

@end
