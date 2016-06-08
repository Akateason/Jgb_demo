//
//  FindingController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-11-8.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "FindingController.h"
#import "FindingCell.h"
#import "UIImageView+WebCache.h"

@interface FindingController () <UITableViewDataSource,UITableViewDelegate>
{
    
}
@end

@implementation FindingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _table.separatorStyle   = UITableViewCellSeparatorStyleNone ;
    
    _table.delegate         = self ;
    _table.dataSource       = self ;
    
    self.isDelBarButton     = YES ;
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
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentfier = @"FindingCell";
    FindingCell *cell = (FindingCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentfier];
    if (cell == nil)
    {
        cell = (FindingCell *)[[[NSBundle mainBundle] loadNibNamed:@"FindingCell" owner:self options:nil] lastObject] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    
    cell.lb_title.text = @"发现发现 发现发现" ;
    cell.lb_time.text  = @"2020-10-10" ;
    cell.imgV.image = [UIImage imageNamed:@"dog.jpg"] ;
//    [cell.imgV setImageWithURL:[NSURL URLWithString:<#(NSString *)#>] placeholderImage:IMG_NOPIC AndSaleSize:CGSizeMake(310*2, 207*2)] ;
    cell.imgV.contentMode = UIViewContentModeScaleToFill ; //UIViewContentModeScaleAspectFit ;
    
    return cell;
}



#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexpath.row : %d",indexPath.row) ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250 ;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil ;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0    ;
}


- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0    ;
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
