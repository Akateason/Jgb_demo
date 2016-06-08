//
//  BindPhoneController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-23.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "BindPhoneController.h"

@interface BindPhoneController ()

@end

@implementation BindPhoneController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_bt_getCheckCode setFont:[UIFont systemFontOfSize:15]] ;
    
    
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction)getCheckCodeAction:(id)sender
{
    
}

- (IBAction)bindAction:(id)sender
{
    
}


@end
