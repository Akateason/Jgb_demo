//
//  MyMessageController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-13.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "MyMessageController.h"
#import "MessageCell.h"
#import "CheckOutHeadFoot.h"

@interface MyMessageController ()
{
    NSMutableArray *m_dataSource ;
}
@end

@implementation MyMessageController

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
    
    //1. set views
    _table.separatorStyle = 0 ;
    
    //2. datasource
    m_dataSource = [NSMutableArray arrayWithArray:@[@"32",@"111",@"as dadsf的奥迪发的说法  离开; ;;",@"ASF阿什顿飞洒地方就看了;离开;离开家;离开离开;就;立刻就看了啥打法是否对经济 快乐撒地方就爱上;对方阿斯达;离开就撒的飞飞啊大师傅阿萨帝发送到",@"ASF爱仕达爱施德飞洒地方萨芬安师大发送到阿萨帝f"]];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return m_dataSource.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"MessageCell";
    MessageCell *cell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (cell == nil) {
        cell = (MessageCell *)[[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone; //选中无背景色
    cell.lb_content.text = [m_dataSource objectAtIndex:indexPath.row];
    cell.line_Is_FME = 0 ;
    if (! indexPath.row ) {
        //first line
        cell.line_Is_FME = -1 ;
    }else if (indexPath.row == m_dataSource.count - 1) {
        //last line
        cell.line_Is_FME =  1 ;
    }
    
    return cell ;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str =  [m_dataSource objectAtIndex:indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:12];
    CGSize size = CGSizeMake(245,100);
    CGSize labelsize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    return 71 - 16 + labelsize.height;
}


#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

// header view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CheckOutHeadFoot *headfoot = (CheckOutHeadFoot *)[[[NSBundle mainBundle] loadNibNamed:@"CheckOutHeadFoot" owner:self options:nil] objectAtIndex:0];
    //            headfoot.backgroundColor = COLOR_LIGHT_GRAY ;
    headfoot.lb_key.text = @"最近更新: 2014-04-06 20:33";
    headfoot.lb_key.font = [UIFont systemFontOfSize:12];
    headfoot.lb_price.hidden = YES ;
    
    return headfoot ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30 ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0 ;
}



@end
