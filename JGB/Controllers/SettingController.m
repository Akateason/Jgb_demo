//
//  SettingController.m
//  JGB
//
//  Created by JGBMACMINI01 on 14-8-21.
//  Copyright (c) 2014年 JGBMACMINI01. All rights reserved.
//

#import "SettingController.h"
#import "AboutUsCell.h"
#import "DigitInformation.h"
#import "MyFileManager.h"
#import "IndexViewController.h"
#import "NavRegisterController.h"

@interface SettingController ()<UIAlertViewDelegate>
{
    
    NSArray *m_picQualityArray ;
    NSArray *m_aboutUsArray ;

}
@end

@implementation SettingController

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
    
    _table.backgroundColor = [UIColor whiteColor] ;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone ;
    
    m_picQualityArray = @[@"智能模式",@"高质量（适合WiFi模式）",@"普通（适合3G或2G环境）"];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"当前版本\t\t\t\t\t\t\t  %@",currentVersion] ;
    
    m_aboutUsArray = @[@"关于我们",@"意见反馈",versionStr] ;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated] ;
    
    _exitButton.hidden = ( (G_TOKEN == nil) || ([G_TOKEN isEqualToString:@""]) ) ;
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
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0)
    {
        //图片质量
        return 3 ;
    }
    else if (section == 1)
    {
        //金箍棒海外购
        return [m_aboutUsArray count];

    }
    
    return 0 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//图片显示质量
    if (! indexPath.section)
    {
        static NSString *TableSampleIdentifier = @"picQualityCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier] ;
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableSampleIdentifier] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;

        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 200, 40)] ;
        lab.text = [m_picQualityArray objectAtIndex:indexPath.row];
        lab.textColor = [UIColor darkGrayColor] ;
        lab.font = [UIFont systemFontOfSize:12.0f] ;
        [cell.contentView addSubview:lab] ;
        cell.tintColor = COLOR_PINK ;
        if (G_IMG_MODE == indexPath.row) cell.accessoryType = UITableViewCellAccessoryCheckmark ;
        else cell.accessoryType = UITableViewCellAccessoryNone ;
        
        [self addBaseLine:cell] ;
        
        return cell ;
    }
    else if ( indexPath.section == 1 )
    {
        static NSString *TableSampleIdentifier = @"aboutUsCell";
        AboutUsCell *cell = (AboutUsCell *)[tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
        if (cell == nil)
        {
            cell = (AboutUsCell *)[[[NSBundle mainBundle] loadNibNamed:@"AboutUsCell" owner:self options:nil] lastObject] ;
        }
        
        cell.accessoryType = (indexPath.row == 2) ? UITableViewCellAccessoryNone :UITableViewCellAccessoryDisclosureIndicator ;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        cell.label.text     = [m_aboutUsArray objectAtIndex:indexPath.row] ;
        cell.label.textColor = [UIColor darkGrayColor] ;
        
        [self addBaseLine:cell] ;
        
        return cell ;
    }

    return nil ;
}

- (void)addBaseLine:(UITableViewCell *)cell
{
    UIView *baseline = [[UIView alloc] initWithFrame:CGRectMake(45, 40, 320-45, 1)] ;
    baseline.backgroundColor = COLOR_BACKGROUND ;
    [cell.contentView addSubview:baseline] ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40 ;
}

#pragma mark --
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section)
    {
        //图片显示质量
        for (int i = 0; i < 3; i++) {
        //全部设none accessory
            NSIndexPath *iPath = [NSIndexPath indexPathForRow:i inSection:0] ;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:iPath] ;
            cell.accessoryType = UITableViewCellAccessoryNone ;
        }
        //打钩 selected
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
        cell.accessoryType = UITableViewCellAccessoryCheckmark ;
        
        NSString *homePath = NSHomeDirectory();
        NSString *path     = [homePath stringByAppendingPathComponent:PATH_SETTING_IMG_SIZE];

        NSNumber *num = [NSNumber numberWithInt:indexPath.row] ;
        [MyFileManager archiveTheObject:num AndPath:path] ;
        G_IMG_MODE = indexPath.row ;
        
    }
    else if (indexPath.section == 1) {
        //金箍棒海外购
        switch (indexPath.row) {
            case 0: //关于我们
            {
                [self performSegueWithIdentifier:@"setting2about" sender:nil] ;
            }
            break;
            case 1: //意见反馈
            {
                [self performSegueWithIdentifier:@"set2return" sender:nil] ;
            }
            break;

            default:
            break;
        }
    }
    
}




// header view
#define HEADHEIGHT          40.0f
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, HEADHEIGHT)] ;
    headView.backgroundColor = [UIColor whiteColor] ;
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, HEADHEIGHT)] ;
    titleLab.font = [UIFont systemFontOfSize:14.0f] ;
    [headView addSubview:titleLab] ;
    
    if (!section) {
        //
        titleLab.text = @"图片显示质量" ;
    }else if (section == 1) {
        //
        titleLab.text = @"金箍棒海外购" ;
    }
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADHEIGHT ;
}

// footer view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] init] ;
    headView.backgroundColor = nil ;
    return headView ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f ;
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
#pragma mark - exit User Action
- (IBAction)exitUserAction:(id)sender
{
    
    if ( (G_TOKEN == nil) || ([G_TOKEN isEqualToString:@""]) )
    {
        [NavRegisterController goToLoginFirstWithCurrentController:self] ;
        return ;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:WD_EXIT_CURRENT_ACCOUNT message:nil delegate:self cancelButtonTitle:WD_EXIT_NO otherButtonTitles:WD_EXIT_YES, nil] ;
    
    [alert show];
    
}


#pragma mark --
#pragma mark - alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex : %d", buttonIndex) ;
    
    if (buttonIndex)
    {
        // exit my account
        G_TOKEN         = @"" ;
        G_USER_CURRENT  = nil ;
        // del the archive
        NSString *homePath = NSHomeDirectory();
        NSString *path = [homePath stringByAppendingPathComponent:PATH_TOKEN_SAVE];
        [MyFileManager deleteFileWithFileName:path] ;
        
        // pop to index view ctrller
        [self back2index] ;
    }
    
}


- (void)back2index
{
    
    [self.navigationController popToRootViewControllerAnimated:YES] ;
}


@end
