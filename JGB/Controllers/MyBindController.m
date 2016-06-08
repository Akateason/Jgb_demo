//
//  MyBindController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyBindController.h"
#import "Bind.h"
#import "ServerRequest.h"

@implementation BindCell



@end


@interface MyBindController ()
{
    NSMutableArray *m_bindList ;
}
@end

@implementation MyBindController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的绑定" ;
    
//*  0手机绑定, 1邮箱绑定, 2微信绑定, 3qq绑定, 4微博绑定   *
    NSArray *strList = @[@"手机绑定", @"邮箱绑定", @"微信绑定", @"QQ绑定", @"微博绑定"] ;
    
    m_bindList = [NSMutableArray array] ;
    for (int i = 0; i < 5; i++)
    {
        Bind *abind     = [[Bind alloc] init] ;
        abind.bindID    = i ;
        abind.name      = strList[i] ;
        abind.isBinded  = NO ;
        
        [m_bindList addObject:abind] ;
    }
    
    _table.delegate     = self ;
    _table.dataSource   = self ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_bindList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"BindCell";
    BindCell *cell = (BindCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil)
    {
        cell = [[BindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
    }
    cell.selectionStyle  = UITableViewCellSelectionStyleNone    ;
    cell.tintColor       = COLOR_PINK ;

    Bind *bind          = m_bindList[indexPath.row] ;
    cell.lb_title.text  = bind.name ;
    cell.lb_bind.text   = bind.isBinded ? @"已绑定" : @"未绑定" ;
    cell.lb_bind.textColor = bind.isBinded ? COLOR_WD_GREEN : COLOR_PINK ;
    
    NSString *imgStr    = [NSString stringWithFormat:@"bind%d",indexPath.row+1] ;
    cell.imgV.image     = [UIImage imageNamed:imgStr]  ;
    cell.imgV.contentMode = UIViewContentModeScaleAspectFill ;
    
    return cell;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//[@"手机绑定", @"邮箱绑定", @"微信绑定", @"QQ绑定", @"微博绑定"] ;
    switch (indexPath.row)
    {
        case 0:
        {
            //手机
            [self performSegueWithIdentifier:@"bind2phone" sender:nil] ;
        }
            break;
        case 1:
        {
            //邮箱
            [self performSegueWithIdentifier:@"bind2email" sender:nil] ;
        }
            break;
        case 2:
        {
            //微信
        }
            break;
        case 3:
        {
            //QQ
        }
            break;
        case 4:
        {
            //微博
        }
            break;
        default:
            break;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f ;
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
