//
//  PaymentViewController.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController
@property(nonatomic, retain) NSString *eventId;
@property(nonatomic, retain) NSString *userId;
//@property(nonatomic, retain) NSString *eventId;
@property (weak, nonatomic) IBOutlet UITextField *payText;
- (IBAction)makePayment:(id)sender;

@end
