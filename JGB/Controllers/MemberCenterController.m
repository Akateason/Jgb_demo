//
//  MemberCenterController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MemberCenterController.h"
#import "DigitInformation.h"
#import "PopMenuView.h"
#import "LSCommonFunc.h"
#import "ServerRequest.h"
#import "UIImageView+WebCache.h"
#import "DealPhotoVideoViewController.h"
#import "YXSpritesLoadingView.h"
#import <AKATeasonFramework/AKATeasonFramework.h>
#import "AFViewShaker.h"
#import "NavRegisterController.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation MemberCell

- (void)awakeFromNib
{
    [super awakeFromNib] ;
    
    _lb_value.hidden = YES ;
}


- (void)setValues:(int)values
{
    _values = values ;
    
    
    if ( values >= 0 )
    {
        _lb_value.text = [NSString stringWithFormat:@"%d",_values] ;
        _lb_value.hidden = NO  ;
    }
    else
    {
        _lb_value.hidden = YES ;
    }
}

- (void)setStrImg:(NSString *)strImg
{
    _strImg = strImg ;
    
    _img.image = [UIImage imageNamed:strImg] ;
    
}

@end


@interface MemberCenterController ()<PopMenuViewDelegate,MemberTopViewDelegate>
{
    NSMutableArray *m_arrList ;

}
@end

@implementation MemberCenterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}


#define MEM_NAME_ORDERLIST  @"我的订单"
#define MEM_NAME_ADDRESS    @"我的地址"
#define MEM_NAME_LIKE       @"我的喜欢"
#define MEM_NAME_COUPSONS   @"我的优惠券"
#define MEM_NAME_POINTS     @"我的积分"


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //DELETE back button
    self.isDelBarButton = YES ;
    
    //1. back view
    self.title = @"会员中心" ;
    
    //2. datasource
    if (!m_arrList)
    {
        m_arrList = [NSMutableArray arrayWithArray:@[MEM_NAME_ORDERLIST,MEM_NAME_ADDRESS,MEM_NAME_LIKE,MEM_NAME_COUPSONS,MEM_NAME_POINTS]] ;
    }
    
    //3. top view
    _topView.delegate = self ;
    
    //4. table view
    _table.delegate         = self                                      ;
    _table.dataSource       = self                                      ;
    _table.separatorStyle   = UITableViewCellSeparatorStyleSingleLine   ;
    _table.separatorInset   = UIEdgeInsetsMake(0, 55, 0, 10)            ;
    _table.separatorColor   = COLOR_LIGHT_GRAY                          ;
    _table.backgroundColor  = [UIColor whiteColor]                      ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    self.navigationController.navigationBar.translucent = YES ;
    [self.navigationController setNavigationBarHidden:YES animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    //
    [self setupTopView] ;
    
    //
    [_table reloadData] ;
}


- (void)setupTopView
{
    _topView.strImg = G_USER_CURRENT.avatar ;
    NSString *strName = (G_USER_CURRENT.nickName) ? G_USER_CURRENT.nickName : @"立即登录" ;
    _topView.strUserName = strName ;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated] ;

    //    shaker
    NSArray * viewlist = @[_topView.lb_userName,_topView.imgHead,_topView.bt_setting] ;
    AFViewShaker *viewShaker = [[AFViewShaker alloc] initWithViewsArray:viewlist];
    [viewShaker shake] ;
}




#pragma mark --
#pragma mark - MemberTopViewDelegate
- (void)settingButtonPressedCallBack
{
    [self performSegueWithIdentifier:@"mem2set" sender:nil] ;
}

- (void)pressedUserInfoCallBack
{
    [self userInfomationPressedAction:nil] ;

}

- (void)pressedHeadCallBack
{
//    [self picHeadpressedAction:nil] ;
    [self userInfomationPressedAction:nil] ;

}





#pragma --
#pragma - Actions
//签到
- (void)signInActionPressed:(id)sender
{
    NSLog(@"signInActionPressed") ;
}

//查看个人信息
- (void)userInfomationPressedAction:(id)sender
{
    
//  if no user here ,  go to login
    if (G_USER_CURRENT.uid == 0 || G_USER_CURRENT == nil)
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
//  if has user here ,  go to user information detail
    [self performSegueWithIdentifier:@"member2selfInfo" sender:nil] ;
}

//picHeadpressedAction
- (void)picHeadpressedAction:(id)sender
{
    
    if (G_USER_CURRENT.uid == 0 || G_USER_CURRENT == nil) return ;
    
    if (G_USER_CURRENT.avatar == nil)
        G_USER_CURRENT.avatar = @"" ;
    else
    {
        [[SDImageCache sharedImageCache] removeImageForKey:G_USER_CURRENT.avatar] ;
    }
    
    NSLog(@"G_USER_CURRENT.avatar : %@",G_USER_CURRENT.avatar) ;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    DealPhotoVideoViewController *detailVC = (DealPhotoVideoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"DealPhotoVideoViewController"] ;
    
    detailVC.m_imgKeyArray          = @[G_USER_CURRENT.avatar] ;
    detailVC.m_currentImgVideoIndex = 0 ;
    detailVC.isRandom = YES ;   //每次查看头像大图,加随机数,更新就的头像缓存
    
    [detailVC setHidesBottomBarWhenPushed:YES] ;
    [self.navigationController pushViewController:detailVC animated:YES] ;
    
}



#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [m_arrList count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"MemberCell";
    MemberCell *cell = (MemberCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil)
    {
        cell = (MemberCell *)[[[NSBundle mainBundle] loadNibNamed:TableSampleIdentifier owner:self options:nil] lastObject] ;
    }
    
    NSString *strTitle = (NSString *)[m_arrList objectAtIndex:indexPath.row] ;
    cell.lb_key.text = strTitle ;
    
    
    cell.strImg = [NSString stringWithFormat:@"memlist%d",indexPath.row + 1] ;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone     ;
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0f ;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}



#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( ( ! G_TOKEN ) || ([G_TOKEN isEqualToString:@""]) )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;        
    }
    
    int section = indexPath.section ;
    int row     = indexPath.row     ;
   
    switch (row) {
        case 0:
        {
            //我的订单
            [self performSegueWithIdentifier:@"member2order" sender:nil] ;
        }
            break;
        case 1:
        {
            //我的地址
            [self performSegueWithIdentifier:@"member2address" sender:nil] ;
        }
            break;
        case 2:
        {
            //我喜欢的
            [self performSegueWithIdentifier:@"member2like" sender:nil] ;
        }
            break;
        case 3:
        {
            //我的优惠券
            [self performSegueWithIdentifier:@"member2coupon" sender:nil] ;
        }
            break;
        case 4:
        {
            //我的积分
            [self performSegueWithIdentifier:@"member2point" sender:nil] ;
        }
            break;
            /*
             case 5:
             {
             //我的评价
             [self performSegueWithIdentifier:@"member2commentlist" sender:nil] ;
             }
             break;
             */
        default:
            break;
    }
    
    
    //  @"我的订单",@"我喜欢的",@"我的地址",@"我的优惠券",@"我的积分",@"我的评价",@"我的消息"]
    /*
    
    switch (indexPath.row)
    {
        case 0://我的订单
        {
            [self performSegueWithIdentifier:@"member2order" sender:nil] ;
        }
            break;
        case 1://我喜欢的
        {
            [self performSegueWithIdentifier:@"member2like" sender:nil] ;
        }
            break;
        case 2://我的地址
        {
            [self performSegueWithIdentifier:@"member2address" sender:nil] ;
        }
            break;
        case 3://我的优惠券
        {
            [self performSegueWithIdentifier:@"member2coupon" sender:nil] ;
        }
            break;
        case 4://我的积分
        {
            [self performSegueWithIdentifier:@"member2point" sender:nil] ;
        }
            break;
        case 5://我的评价
        {
            [self performSegueWithIdentifier:@"member2commentlist" sender:nil] ;
        }
            break;

        default:
            break;
            
//        case 5://我的绑定
//        {
//            [self performSegueWithIdentifier:@"member2mybind" sender:nil] ;
//        }
//            break;
//        case 6://我的消息
//        {
//            [self performSegueWithIdentifier:@"member2message" sender:nil] ;
//        }
//            break;
     }
            */
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self getEmptyView] ;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
}

- (UIView *)getEmptyView
{
    UIView *empty = [[UIView alloc] init] ;
    empty.backgroundColor = nil ;
    return empty ;
}






#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    
}

@end




