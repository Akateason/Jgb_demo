//
//  NavRegisterController.m
//  JGB
//
//  Created by JGBMACMINI01 on 15-1-31.
//  Copyright (c) 2015年 JGBMACMINI01. All rights reserved.
//
#import "MyWebController.h"
#import "NavRegisterController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "DigitInformation.h"
#import "LoginFirstController.h"

@interface NavRegisterController ()

@end

@implementation NavRegisterController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated .
}



#pragma mark --
#pragma mark -
+ (void)goToLoginFirstWithCurrentController:(UIViewController *)controller AppLoginFinished:(BOOL)bFinished
{
    UIStoryboard          *story    = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    NavRegisterController *navCtrl  = [story instantiateViewControllerWithIdentifier:@"NavRegisterController"] ;

    
    [controller presentViewController:navCtrl animated:YES completion:^{
    }] ;
}

+ (void)goToLoginFirstWithCurrentController:(UIViewController *)controller
{
    [[self class] goToLoginFirstWithCurrentController:controller AppLoginFinished:NO] ;
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
