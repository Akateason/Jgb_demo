//
//  NavViewController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-5.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "NavViewController.h"
#import <AKATeasonFramework/AKATeasonFramework.h>

@interface NavViewController ()

@end

@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // fix 'nested pop animation can result in corrupted navigation bar'
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

//- (void)navigationController:(UINavigationController *)navigationController
//       didShowViewController:(UIViewController *)viewController
//                    animated:(BOOL)animated
//{
//    if (viewController == self.pushingViewController) {
//        self.supportPan2Pop = YES;
//        self.pushingViewController = nil;
//    }
//}



//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    UIViewController *vc = [super popViewControllerAnimated:animated];
//    
////    [self myAnimation:NO AndWithController:vc] ;
//    
//    return vc ;
//}

#define MY_DURATION   0.75
- (void)myAnimation:(BOOL)isOpen AndWithController:(UIViewController *)ctrl
{
    // Animation
//    CABasicAnimation *animation = [TeaAnimation verticalRotationWithDuration:MY_DURATION degree:-90 direction: -1 repeatCount:1] ;
//    
//    [ctrl.view.layer addAnimation:animation forKey:nil] ;
    
//    [UIView beginAnimations:@"animation" context:nil];
//    [UIView setAnimationDuration:MY_DURATION];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    
//    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown    forView:ctrl.view cache:NO];
//    [UIView commitAnimations];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
