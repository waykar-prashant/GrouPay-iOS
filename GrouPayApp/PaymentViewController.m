//
//  PaymentViewController.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/7/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "PaymentViewController.h"
#import "HttpUtil.h"
#import "EventDetailVC.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController
@synthesize eventId, userId, payText;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)cancelAction
{
    NSLog(@"CANCEL");
    //Push Modal Screen for adding a new Group
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"on completion");
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)makePayment:(id)sender {
    //submit amount to the server
    NSString *amount = payText.text;
    NSDictionary *temp = [HttpUtil makePayment:userId with:eventId and:amount];
    if(temp != nil) {
        /*[self dismissViewControllerAnimated:YES completion:^{
            NSLog(@"on completion");
        }];*/
    }
    
    int index = 0;
    NSArray *array = [self.navigationController viewControllers];
    for(UIViewController *viewController in self.navigationController.viewControllers){
        if ([viewController isMemberOfClass:[EventDetailVC class]]) {
            break;
        }
        index++;
    }
    [self.navigationController popToViewController:[array objectAtIndex:index] animated:YES];

}
@end
