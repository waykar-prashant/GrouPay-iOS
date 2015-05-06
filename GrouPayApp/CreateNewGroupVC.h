//
//  CreateNewGroupVC.h
//  GrouPayApp
//
//  Created by Prashant S Waykar on 5/5/15.
//  Copyright (c) 2015 Prashant S Waykar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPTAddArticleDelegate <NSObject>

//-(void) addArticleName:(NSString *)strName andArticleDesc:(NSString *) strArticleDesc;
-(void) addGroupName:(NSString *)strName andGroupId:(NSString *) strGroupId;
@end
@interface CreateNewGroupVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (unsafe_unretained) id <SPTAddArticleDelegate> delegate;
- (void)saveAction;
- (void)cancelAction;


@end
