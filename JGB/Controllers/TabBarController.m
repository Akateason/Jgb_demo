//
//  TabBarController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-11.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "TabBarController.h"
#import "ShopCarViewController.h"
#import "ColorsHeader.h"



//  购物车排列下标
#define SHOP_CAR_TAB_BAR_ITEM   2



@interface TabBarController ()<UITabBarControllerDelegate,DigitInfomationDelegate>

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad]  ;
    // Do any additional setup after loading the view.
    
//    [self setSelImgList] ;
    
    [self setBackgroundImg] ;
    
    NSLog(@"%lf",[[[UIDevice currentDevice] systemVersion] floatValue]) ;
    
    BOOL b71 = IS_IOS_VERSION(7.1f) ;
    BOOL b70 = IS_IOS_VERSION(7.0f) ;

    if (b71)
    {
        [_myTabBar setSelectedImageTintColor:COLOR_PINK] ;
        
        
        UIImage *Uimg1 = [[UIImage imageNamed:@"barbuttons_1.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *Simg1 = [UIImage imageNamed:@"barbutSelect_1.png"];
        UITabBarItem *item1 = [_myTabBar.items objectAtIndex:0];
        [item1 setFinishedSelectedImage:Simg1 withFinishedUnselectedImage:Uimg1];
        
        UIImage *Uimg2 = [[UIImage imageNamed:@"barbuttons_2.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *Simg2 = [UIImage imageNamed:@"barbutSelect_2.png"];
        UITabBarItem *item2 = [_myTabBar.items objectAtIndex:1];
        [item2 setFinishedSelectedImage:Simg2 withFinishedUnselectedImage:Uimg2];
        
        UIImage *Uimg3 = [[UIImage imageNamed:@"barbuttons_3.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *Simg3 = [UIImage imageNamed:@"barbutSelect_3.png"];
        UITabBarItem *item3 = [_myTabBar.items objectAtIndex:2];
        [item3 setFinishedSelectedImage:Simg3 withFinishedUnselectedImage:Uimg3];
        
        UIImage *Uimg4 = [[UIImage imageNamed:@"barbuttons_4.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        UIImage *Simg4 = [UIImage imageNamed:@"barbutSelect_4.png"];
        UITabBarItem *item4 = [_myTabBar.items objectAtIndex:3];
        [item4 setFinishedSelectedImage:Simg4 withFinishedUnselectedImage:Uimg4];
        
    }
    else if (b70)
    {
        [_myTabBar setTintColor:COLOR_PINK] ;
        _myTabBar.translucent = NO  ;
        
        UIEdgeInsets edge = UIEdgeInsetsMake(0, -5, 0, 5) ;
        
        UIImage *Uimg1 = [[UIImage imageNamed:@"barbuttons_1.png"]      resizableImageWithCapInsets:edge];
        UIImage *Simg1 = [[UIImage imageNamed:@"barbutSelect_1.png"]    resizableImageWithCapInsets:edge];
        UITabBarItem *item1 = [_myTabBar.items objectAtIndex:0];
        [item1 setFinishedSelectedImage:Simg1 withFinishedUnselectedImage:Uimg1];
        
        UIImage *Uimg2 = [[UIImage imageNamed:@"barbuttons_2.png"]      resizableImageWithCapInsets:edge];
        UIImage *Simg2 = [[UIImage imageNamed:@"barbutSelect_2.png"]    resizableImageWithCapInsets:edge];
        UITabBarItem *item2 = [_myTabBar.items objectAtIndex:1];
        [item2 setFinishedSelectedImage:Simg2 withFinishedUnselectedImage:Uimg2];
        
        UIImage *Uimg3 = [[UIImage imageNamed:@"barbuttons_3.png"]      resizableImageWithCapInsets:edge];
        UIImage *Simg3 = [[UIImage imageNamed:@"barbutSelect_3.png"]    resizableImageWithCapInsets:edge];
        UITabBarItem *item3 = [_myTabBar.items objectAtIndex:2];
        [item3 setFinishedSelectedImage:Simg3 withFinishedUnselectedImage:Uimg3];
        
        UIImage *Uimg4 = [[UIImage imageNamed:@"barbuttons_4.png"]      resizableImageWithCapInsets:edge];
        UIImage *Simg4 = [[UIImage imageNamed:@"barbutSelect_4.png"]    resizableImageWithCapInsets:edge];
        UITabBarItem *item4 = [_myTabBar.items objectAtIndex:3];
        [item4 setFinishedSelectedImage:Simg4 withFinishedUnselectedImage:Uimg4];
        
    }
    
    self.delegate = self ;
    
    [DigitInformation shareInstance].delegate = self ;
    

}

- (void)setBackgroundImg
{
    CGRect frame    = CGRectMake(0.0, 0, 320, 49)               ;
    UIView *v       = [[UIView alloc] initWithFrame:frame]      ;
    [v setBackgroundColor:[UIColor whiteColor]] ;    //COLOR_GRAY_BAR
    [_myTabBar insertSubview:v atIndex:0];
}


//- (void)setSelImgList
//{
//    NSMutableArray *imgSelList = [NSMutableArray array] ;
//    for (int i = 1; i < 6; i++)
//    {
//        NSString *imgStr = [NSString stringWithFormat:@"barSel%d",i] ;
//
//        if (i == 3) continue ;
//        
//        [imgSelList addObject:imgStr] ;
//    }
//    
//    int i = 0 ;
//    
//    for (UITabBarItem *item in _myTabBar.items)
//    {
//        UIImage * selectImage = [[UIImage imageNamed:imgSelList[i]]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        item.selectedImage = selectImage ;
//        i++ ;
//    }
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == SHOP_CAR_TAB_BAR_ITEM)
    {
        // tab select shop car
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HIDE_SHOPCAR_BACK object:nil] ;
    }
}


#pragma mark - DigitInfomationDelegate
- (void)setMyTabBarItemChange
{
//    [[_myTabBar.items objectAtIndex:SHOP_CAR_TAB_BAR_ITEM] setBadgeValue:[NSString stringWithFormat:@"%d",G_SHOP_CAR_COUNT]];
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
