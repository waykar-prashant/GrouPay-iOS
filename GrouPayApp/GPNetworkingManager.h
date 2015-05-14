//
//  GPNetworkingManager.h
//  GrouPayApp
//
//  Created by Prashant Waykar on 11/05/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPNetworkingManager : NSObject

+ (void)sendRequestWithURLString:(NSString *)urlStr parameters:(NSDictionary *)parameters completionHandler:(void (^) (NSError *error, NSDictionary *responseDictionary))completionHandler;

@end
