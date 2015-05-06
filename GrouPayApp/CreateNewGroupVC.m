//
//  CreateNewGroupVC.m
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import "CreateNewGroupVC.h"
#import "AppDelegate.h"
#import "HttpUtil.h"


//AppDelegate *appDelegate;

@interface CreateNewGroupVC ()

@end

@implementation CreateNewGroupVC
@synthesize groupNameTextField, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    NSArray *rightActionButtonItems = @[doneButton];
    self.navigationItem.rightBarButtonItems = rightActionButtonItems;

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    NSArray *leftActionButtonItems = @[cancelButton];
    self.navigationItem.leftBarButtonItem = leftActionButtonItems;*/
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveAction)];

}


-(void)saveAction
{
    NSLog(@"DONE -- Create a group with group name : %@", [groupNameTextField text]);
   // appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //NSString *user_id = appDelegate.userDetails.user_id;
    NSString *user_id = @"101";
    NSString *group_name = [groupNameTextField text];
    NSString *groupId = @"201";
    NSLog(@"USER ID: %@, ",user_id);
    
    /*NSDictionary *myGroupDetails = [HttpUtil createGroup:user_id with:group_name];
    if(myGroupDetails !=nil){
        //Hide the UI and show the group name added to the list
    }else{
        NSLog(@"Group Not Created");
    }*/
    //Push Modal Screen for adding a new Group
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if((![self.groupNameTextField.text isEqualToString:@""]))
    {
        if([self.delegate respondsToSelector:@selector(addGroupName:andGroupId:)])
        {
            [self.delegate addGroupName:self.groupNameTextField.text andGroupId:@"101"];
            //[self.delegate addArticleName:self.groupNameTextField.text andArticleDesc:self.txtArticleDesc.text];
        }
    }
    
}

-(void)cancelAction
{
    NSLog(@"CANCEL");
    //Push Modal Screen for adding a new Group
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"on completion");
    }];
    
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

@end
