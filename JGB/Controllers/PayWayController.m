//
//  PayWayController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-10-20.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "PayWayController.h"

@implementation PayCell

@end



@interface PayWayController ()

@end

@implementation PayWayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
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
    return _paywayList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"PayCell"                 ;
    PayCell *cell = (PayCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil)
    {
        cell = [[PayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentfier] ;
    }
    
    Payway *_payw = [_paywayList objectAtIndex:indexPath.row]   ;
    
    cell.imgV.image = [UIImage imageNamed:_payw.payStr]         ;
    cell.tintColor  = COLOR_PINK                                ;

    cell.backgroundColor = [UIColor clearColor]                 ;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone    ;
    
    cell.accessoryType = (_payw.isChoosen) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone ;
    
    return cell                         ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (Payway *_payw in _paywayList)
    {
        _payw.isChoosen = NO ;
    }
    
    ((Payway *)_paywayList[indexPath.row]).isChoosen = YES ;
    
    [self.delegate sendPayWayList:_paywayList] ;
    
    [tableView reloadData] ;

    [self performSelector:@selector(goBack) withObject:nil afterDelay:0.5f] ;
}


- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES] ;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *bgView = [[UIView alloc] init] ;
//    bgView.backgroundColor = [UIColor clearColor] ;
//
//    return  bgView ;
//}
//
//- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 1 ;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
