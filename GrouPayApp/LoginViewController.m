//
//  LoginViewController.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpUtil.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize emailTextField,passwordTextField;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    
    NSLog(@"submit Login");
    //self.loginActivityIndication.hidden = FALSE;
    //[self.loginActivityIndication startAnimating];
    if ([HttpUtil checkLogin:[emailTextField text] with:[passwordTextField text]])
    {
        //download the json and parse it and save it
        //Pass the data to the segue
        NSLog(@"download json and parse data");
        
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }else{
        NSLog(@"LOGIN FAILED!!");
        //self.loginActivityIndication.hidden = TRUE;
        //[self.loginActivityIndication stopAnimating];
    }
}

- (IBAction)register:(id)sender {
}
@end
